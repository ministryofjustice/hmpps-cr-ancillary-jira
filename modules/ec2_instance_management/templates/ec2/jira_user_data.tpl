#!/usr/bin/env bash
set -x



cat << EOF > ~/getcreds
#!/usr/bin/env bash
export db_master_password="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/${jira_type}/jira/rds_master_password" \
--query Parameters | jq -r .[].Value)"

export jira_admin_password="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/${jira_type}/jira/jira_admin_password" \
--query Parameters | jq -r .[].Value)"

export jira_smtp_password="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"${jira_smtp_password_ssmparam}" \
--query Parameters | jq -r .[].Value)"

EOF
chmod u+x ~/getcreds

# get ssm parameters for bootstrap ansible
. ~/getcreds

# log bootstrap after creds obtained
touch /var/log/user-data.log
chmod 600 /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

cat << EOF >> /etc/environment
export HMPPS_ROLE="${app_name}"
export HMPPS_FQDN="${server_name}.${public_domain}"
export HMPPS_STACKNAME=${env_identifier}
export HMPPS_STACK="${short_env_identifier}"
export HMPPS_ENVIRONMENT="${route53_sub_domain}"
export HMPPS_ACCOUNT_ID="${aws_account_id}"
export HMPPS_DOMAIN="${public_domain}"
export INSTANCE_ID="`curl http://169.254.169.254/latest/meta-data/instance-id`"
export REGION="${region}"
export APPLICATION="${application}"
export JIRA_VERSION="${jira_version}"
export JIRA_EFS_VOLUME_ID="${jira_data_volume_id}"
export DB_MASTER_USER="${db_master_user}"
export JIRA_DB_ENDPOINT="${jira_db_endpoint}"
export JIRA_HOME="/var/jira"
export JIRA_CLOUDWATCH_LOG_GROUP="${jira_cloudwatch_log_group}"
export JIRA_SMTP_USER="${jira_smtp_user}"
export JIRA_SMTP_ENDOPINT="${jira_smtp_endpoint}"
EOF

# Add in JAVA_HOME value
echo "export JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home'| awk '{print $3}')" >> /etc/environment

## Ansible runs in the same shell that has just set the env vars for future logins so it has no knowledge of the vars we've
## just configured, so lets export them
$(cat /etc/environment)

cat << EOF > ~/requirements.yml
---

- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-bootstrap
  version: centos
- name: users
  src: https://github.com/singleplatform-eng/ansible-users
- name: jira-bootstrap
  src: https://github.com/ministryofjustice/hmpps-engineering-jira-bootstrap.git
  version: jira_7_0
EOF


/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml

cat << EOF >> ~/.bash_profile

alias getenv='. /etc/environment && cat /etc/environment'
alias creds='. ~/getcreds && . /etc/environment'
alias mycli='mysql --host="\$JIRA_DB_ENDPOINT" --user="\$DB_MASTER_USER" --password="\$db_master_password" jira'
alias tailudl='tail -n 100 -F /var/log/user-data.log'
alias udl='less +G /var/log/user-data.log'
alias ud='less /var/lib/cloud/instance/user-data.txt'
alias catalinalog='tail -n 100 -F /home/${jira_user}/${jira_filename}-${jira_version}-standalone/logs/catalina.out'
alias src='. ~/.bash_profile'
EOF

# Setup Ansible Vars
cat << EOF > ~/vars.yml
# Cloudwatch Logs
region: "${region}"
cwlogs_log_group: "${jira_cloudwatch_log_group}"
# JIRA
jira_user: ${jira_user}
jira_group: ${jira_group}
jira_smtp_user: ${jira_smtp_user}
jira_smtp_endpoint: ${jira_smtp_endpoint}
jira_smtp_port: ${jira_smtp_port}
jira_smtp_starttls: ${jira_smtp_starttls}
jira_version: ${jira_version}
jira_filename: ${jira_filename}
jira_db_name: ${jira_db_name}
jira_db_endpoint: ${jira_db_endpoint}
db_master_user: ${db_master_user}
jira_data_volume_id: ${jira_data_volume_id}
jira_external_endpoint: ${jira_external_endpoint}
mysql_connector_version: ${mysql_connector_version}
# For user_update cron
remote_user_filename: "${bastion_inventory}"
EOF

# Create bootstrap playbook
cat << EOF > ~/ansible_bootstrap.yml
---

- hosts: localhost
  vars_files:
   - "{{ playbook_dir }}/vars.yml"
   - "{{ playbook_dir }}/users.yml"
  roles:
     - bootstrap
     #- users
     - jira-bootstrap
EOF

# Create boot script to allow for easier reruns if needed
cat << EOF > ~/runboot.sh
#!/usr/bin/env bash
. ~/getcreds
. /etc/environment
export ANSIBLE_LOG_PATH=\$HOME/.ansible.log
ansible-galaxy install -f -r ~/requirements.yml
ansible-playbook ~/ansible_bootstrap.yml \
-b -vvvv \
--extra-vars "{ \
'db_master_password':'\$db_master_password', \
'jira_admin_password':'\$jira_admin_password', \
'jira_smtp_password':'\$jira_smtp_password', \
'java_home':'\$JAVA_HOME' \
}"
EOF
#
chmod u+x ~/runboot.sh

# Run the boot script
~/runboot.sh
