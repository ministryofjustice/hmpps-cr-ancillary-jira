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
  ansible \
  socat \
  vim

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install



popd

cat << EOF > ~/.vimrc
" ls -l /usr/share/vim/vim80/colors
colorscheme desert
set paste
set ruler

" basic settings for yaml and python files
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab number autoindent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab autoindent

" folding can help troubleshoot indentation syntax
set foldenable
set foldlevelstart=20
set foldmethod=indent
nnoremap <space> za
EOF

cat << EOF > ~/getcreds
#!/usr/bin/env bash
export RDS_CLUSTER_MASTER_USERNAME="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/rds_cluster_master_username" \
--query Parameters | jq -r .[].Value)"

export RDS_CLUSTER_MASTER_PASSWORD="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/rds_cluster_master_password" \
--query Parameters | jq -r .[].Value)"

export JIRA_DB_USER="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/jira_db_user" \
--query Parameters | jq -r .[].Value)"

export JIRA_DB_USER_PASSWORD="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/jira_db_user_password" \
--query Parameters | jq -r .[].Value)"

export DATABASE_NAME="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/database_name" \
--query Parameters | jq -r .[].Value)"

export DB_ENDPOINT="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/db_endpoint" \
--query Parameters | jq -r .[].Value)"

export DB_PORT="\$(aws ssm get-parameters \
--region ${region} \
--with-decryption --name \
"/${environment_name}/jira/db_port" \
--query Parameters | jq -r .[].Value)"

export JIRA_ADMIN_PASSWORD="\$(aws ssm get-parameters \
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
export JIRA_ALB_FQDN="${alb_fqdn}"

export JIRA_CLOUDWATCH_LOG_GROUP="${jira_cloudwatch_log_group}"
export PGPASSFILE="~/.pgpass"
EOF


cat << EOF >> ~/.bash_profile

alias getenv='. /etc/environment && cat /etc/environment'
alias creds='. ~/getcreds && . /etc/environment'
alias mycli='mysql --host="\$JIRA_DB_ENDPOINT" --user="\$DB_MASTER_USER" --password="\$DB_MASTER_PASSWORD" jira'
alias tailudl='tail -n 100 -F /var/log/user-data.log'
alias udl='less +G /var/log/user-data.log'
alias ud='less /var/lib/cloud/instance/user-data.txt'
alias catalinalog='tail -n 100 -F /home/logs/catalina.out'
alias src='. ~/.bash_profile'
alias postgresrds=". /etc/environment && socat TCP-LISTEN:5432,reuseaddr,fork TCP4:\$JIRA_DB_ENDPOINT:5432"
alias dbcli="psql -h \$db_endpoint -p \$db_port -U jira jira"
EOF

. ~/getcreds && . /etc/environment

cat << EOF >> ~/.pgpass
\$DB_ENDPOINT:\$DB_PORT:\$DATABASE_NAME:\$RDS_CLUSTER_MASTER_USERNAME:\$RDS_CLUSTER_MASTER_PASSWORD
EOF

chmod 0600 ~/.pgpass
export PGPASSFILE='~/.pgpass'

## Ansible requirements
cat << EOF > ~/requirements.yml
---

- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-cr-ancillary-jira-ansible
  version: testing
EOF

# Setup Ansible Vars
cat << EOF > ~/vars.yml
jira_data_volume_id: ${jira_data_volume_id}
jira_db_host: ${jira_db_endpoint}
jira_db_master_username: ${jira_db_master_username}
sharedhome_path: ${sharedhome_path}
shared_home_volume_name: ${shared_home_volume_name}
shared_home_volume_root_dir: ${shared_home_volume_root_dir}
jira_config_path: ${jira_config_path}
jira_config_volume_name: ${jira_config_volume_name}
jira_config_volume_root_dir: ${jira_config_volume_root_dir}
alb_fqdn: ${alb_fqdn}
cwlogs_log_group: ${jira_cloudwatch_log_group}
region: ${region}
instance_id: `curl http://169.254.169.254/latest/meta-data/instance-id`

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
'jira_db_master_password':'\$RDS_CLUSTER_MASTER_PASSWORD', \
'jira_db_user_password':'\$JIRA_DB_USER_PASSWORD' \
}"
EOF
#
chmod u+x ~/runboot.sh

# Run the boot script
~/runboot.sh

docker pull atlassian/jira-servicemanagement
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
