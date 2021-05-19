# Jira Service Desk
## HMPPS Community Rehabilitation Ancillary Applications

Jira Service Desk - This product is now called “Jira Service Management”.

##Environment
The Jira Service Management (JSM) is hosted in an AWS Account managed and run by MOJ.



|   Account Name      	| Account ID       	| Environment Config Label 	|
|---------	|------------------	|----------------	|
| hmpps-cr-jira-production  	| 172219029581 	| [cr-jira-prod](https://github.com/ministryofjustice/hmpps-env-configs/tree/master/cr-jira-prod) 	|
| hmpps-cr-jira-non-production 	| 529698415668   	| [cr-jira-dev](https://github.com/ministryofjustice/hmpps-env-configs/tree/master/cr-jira-dev) 	|

The diagram to the left shows the VPC, subnets and resources. This is the current IA as deployed to meet MVP1*.
The VPC will have a CIDR of 10.163.32.0/20 with three groups of subnets spanning all three Availability Zones (AZ). Routing allows traffic for updates etc out via a Nat Gateway placed in each public subnet. There is no route from the public subnet to the data subnet.
VPC subnets:

|         	| eu-west-2a       	| eu-west-2a     	| eu-west-2a       	|
|---------	|------------------	|----------------	|------------------	|
| Public  	| 10.163.46.128/25 	| 10.163.47.0/25 	| 10.163.47.128/25 	|
| Private 	| 10.163.32.0/22   	| 10.163.36.0/22 	| 10.163.40.0/22   	|
| Data    	| 10.163.44.0/24   	| 10.163.45.0/24 	| 10.163.46.0/25   	|

Application load balancers in each public subnet forward traffic onto the Jira endpoint in either an EC2 Autoscaling group ((of one) MVP1) or ECS Cluster with Fargate launch provider.
##Service
The JSM application will run via the Atlassian official Docker images pulled from Docker Hub https://hub.docker.com/r/atlassian/jira-servicemanagement/
For bootstrapping and MVP1 the image is run on an AWS ECS Optimised AMI in an Autoscaling Group. This enables more control over service as the start up time for initial bootstrapping of a blank install exceeds the load balancer health check timeout. Next phase will have the service configured as cluster on ECS using Fargate as the launch provider. Fargate removes the requirement to deploy and manage EC2 instances for the running ECS tasks.
##Storage
Data uploaded as attachments, plugin binaries will be persisted on EFS cluster across AZs for uninterrupted service during an AZ outage.
Database is Postgres on Amazon Aurora for durability and uninterrupted service during an AZ outage.
##Backup
EFS cluster uses the AWS Backup service with it’s own vault, backing up nightly.
Database uses Snapshots nightly.
##Access
Each resource/service has Security Groups (SGs) to restrict egress and ingress. These are tied to each other within the VPC - for example egress from the Jira SG to ingress on the Database SG.
The SG around the Load balancers currently only accept requests on port 443 https from DOM1 and MOJ VPN CIDRS (and specific engineers IPs during development).
##Email
AWS Simple Email Service (SES) has been configured to enable email from Jira to user’s emails for issue status, assignment etc.
##Logging and Monitoring
Logs are shipped to AWS Cloudwatch. Dashboards will be configured to show service performance. Alerts will be configured to inform of service degradation. 
