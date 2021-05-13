#!/usr/bin/env bash

## use env name as first argument
## defaults to dev


export ENVIRONMENT_NAME=${1:-cr-jira-dev}

echo "ENVIRONMENT_NAME -- ${ENVIRONMENT_NAME}"
export AWS_PROFILE=${ENVIRONMENT_NAME}

PARAM=$(aws ssm get-parameters \
--region eu-west-2 \
--with-decryption --name \
"/${ENVIRONMENT_NAME}/jira_test/jira_test_user_password" \
"/${ENVIRONMENT_NAME}/jira_test/jira_test_username" \
"/${ENVIRONMENT_NAME}/jira_test/jira_test_full_name" \
"/${ENVIRONMENT_NAME}/jira_test/jira_test_user_email" \
--query Parameters)
export jira_test_user_password="$(echo $PARAM | jq '.[] | select(.Name | test("jira_test_user_password")) | .Value' --raw-output)"
export jira_test_username="$(echo $PARAM | jq '.[] | select(.Name | test("jira_test_username")) | .Value' --raw-output)"
export jira_test_full_name="$(echo $PARAM | jq '.[] | select(.Name | test("jira_test_full_name")) | .Value' --raw-output)"
export jira_test_user_email="$(echo $PARAM | jq '.[] | select(.Name | test("jira_test_user_email")) | .Value' --raw-output)"

env | sort | grep "jira_test_"
