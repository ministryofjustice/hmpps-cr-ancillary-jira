[{
    "name": "${container_name}",
    "image": "${image_url}:${image_version}",
    "essential": true,
    "interactive": true,
    "healthCheck": {
        "command": [ "CMD-SHELL", "curl -s http://localhost:8080/status" ],
        "interval": 60,
        "retries": 2,
        "startPeriod": 60,
        "timeout": 5
    },
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${log_group_name}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "ecs-${container_name}"
        }
    },
    "environment": [
        {
            "name": "AWS_REGION",
            "value": "${region}"
        },
        {
            "name": "CLUSTERED",
            "value": "${clustered}"
        },
        {
            "name": "JIRA_HOME",
            "value": "${container_jira_home}"
        },
        {
            "name": "JIRA_SHARED_HOME",
            "value": "${container_jira_shared_home}"
        },
        {
            "name": "ATL_PROXY_NAME",
            "value": "${alb_fqdn}"
        },
        {
            "name": "ATL_PROXY_PORT",
            "value": "443"
        },
        {
            "name": "ATL_TOMCAT_SCHEME",
            "value": "https"
        },
        {
            "name": "ATL_TOMCAT_SECURE",
            "value": "true"
        },
        {
            "name": "ATL_AUTOLOGIN_COOKIE_AGE",
            "value": "${jc_login_duration}"
        },
        {
            "name": "ATL_JDBC_URL",
            "value": "jdbc:postgresql://${jira_db_endpoint}:5432/jira?targetServerType=master"
        },
        {
            "name": "ATL_JDBC_USER",
            "value": "${jira_db_user}"
        },
        {
            "name": "ATL_DB_DRIVER",
            "value": "${jira_db_driver}"
        },
        {
            "name": "ATL_DB_TYPE",
            "value": "${jira_db_type}"
        },
        {
            "name": "ATL_DB_SCHEMA_NAME",
            "value": "public"
        }
      ],
    "secrets": [
        {
            "name": "ATL_JDBC_PASSWORD",
            "valueFrom": "${jira_db_user_password}"
        }
    ],
    "volumesFrom": [],
    "mountPoints": [
        {
            "containerPath": "${container_jira_home}",
            "sourceVolume": "${src_jira_home_node1}"
        },
        {
            "containerPath": "${container_jira_shared_home}",
            "sourceVolume": "${src_shared_home}"
        }
    ],
    "portMappings": [
        {
            "containerPort": ${service_port},
            "hostPort": ${service_port},
            "protocol": "tcp"
        },
        {
            "containerPort": ${ehcache_listener_port},
            "hostPort": ${ehcache_listener_port},
            "protocol": "tcp"
        }
    ]
}]
