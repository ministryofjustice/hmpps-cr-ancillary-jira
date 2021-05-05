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
            "value": "false"
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
            "value": "HTTPS"
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
            "value": "${jira_db_endpoint}"
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
            "value": "${jira_db_user}"
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
            "containerPath": "${sharedhome_path}",
            "sourceVolume": "${shared_home_volume_name}"
        },
        {
            "containerPath": "${jira_config_path}",
            "sourceVolume": "${jira_config_volume_name}"
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
