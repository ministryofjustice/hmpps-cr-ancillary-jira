#!/usr/bin/env bash
set -x

pushd /tmp

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo amazon-linux-extras install epel -y
sudo yum update

sudo yum install -y \
  unzip \
  git \
  jq \
  tree \
  amazon-efs-utils \
  awslogs \
  gcc \
  postgresql \
  pip \
  ansible

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install



popd

cat << EOF > ~/getcreds
#!/usr/bin/env bash
export rds_cluster_master_username="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/rds_cluster_master_username" \
--query Parameters | jq -r .[].Value)"

export rds_cluster_master_password="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/rds_cluster_master_password" \
--query Parameters | jq -r .[].Value)"

export jira_db_user="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/jira_db_user" \
--query Parameters | jq -r .[].Value)"

export jira_db_user_password="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/jira_db_user_password" \
--query Parameters | jq -r .[].Value)"

export database_name="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/database_name" \
--query Parameters | jq -r .[].Value)"

export db_endpoint="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/db_endpoint" \
--query Parameters | jq -r .[].Value)"

export db_port="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/db_port" \
--query Parameters | jq -r .[].Value)"

export jira_admin_password="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/jira_admin_password" \
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
export HMPPS_ACCOUNT_ID="${aws_account_id}"
export INSTANCE_ID="`curl http://169.254.169.254/latest/meta-data/instance-id`"
export REGION="${region}"
export JIRA_EFS_VOLUME_ID="${jira_data_volume_id}"
export JIRA_DB_ENDPOINT="${jira_db_endpoint}"
export JIRA_HOME="/var/jira"
export PGPASSFILE="~/.pgpass"
EOF


cat << EOF >> ~/.bash_profile

alias getenv='. /etc/environment && cat /etc/environment'
alias creds='. ~/getcreds && . /etc/environment'
alias mycli='mysql --host="\$JIRA_DB_ENDPOINT" --user="\$DB_MASTER_USER" --password="\$db_master_password" jira'
alias tailudl='tail -n 100 -F /var/log/user-data.log'
alias udl='less +G /var/log/user-data.log'
alias ud='less /var/lib/cloud/instance/user-data.txt'
alias catalinalog='tail -n 100 -F /home/logs/catalina.out'
alias src='. ~/.bash_profile'
EOF

. ~/getcreds && . /etc/environment

cat << EOF >> ~/.pgpass
\$db_endpoint:\$db_port:\$database_name:\$rds_cluster_master_username:\$rds_cluster_master_password
EOF

chmod 0600 ~/.pgpass
export PGPASSFILE='~/.pgpass'

## Ansible requirements
cat << EOF > ~/requirements.yml
---

- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-cr-ancillary-jira-ansible
EOF

# Setup Ansible Vars
cat << EOF > ~/vars.yml
jira_data_volume_id: ${jira_data_volume_id}
jira_db_host: ${db_endpoint}
jira_db_master_username: ${rds_cluster_master_username}
jira_db_master_password: ${rds_cluster_master_password}
jira_db_user_password:


EOF

# Create bootstrap playbook
cat << EOF > ~/ansible_bootstrap.yml
---

- hosts: localhost
  vars_files:
    - "{{ playbook_dir }}/vars.yml"
  roles:
    - bootstrap
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
'jira_db_master_password':'\$rds_cluster_master_password', \
'jira_db_user_password':'\$jira_db_user_password' \
}"
EOF
#
chmod u+x ~/runboot.sh

# Run the boot script
~/runboot.sh
