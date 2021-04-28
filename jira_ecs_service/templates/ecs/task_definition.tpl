[{
    "name": "${container_name}",
    "image": "${image_url}:${image_version}",
    "essential": true,
    "interactive": true,
    "healthCheck": {
        "command": [ "CMD-SHELL", "curl -s http://localhost:8080/health/ping" ],
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
        }
      ],
    "secrets": [],
    "volumesFrom": [],
    "mountPoints": [],
    "portMappings": [
        {
               "containerPort": ${service_port},
               "hostPort": ${service_port},
               "protocol": "tcp"
            }
    ],
    "cpu": 0
}]
