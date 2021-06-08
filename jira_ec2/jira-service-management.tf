## Jira 6.4
#



module "jira_ec2" {
  source = "../modules/jira"

  # standard data
  jira_data = {
    aws_account_id          = data.aws_caller_identity.current.id
    region                  = data.aws_region.current.name
    internal_zone_id        = data.terraform_remote_state.vpc.outputs.zone["private"]["id"]
    internal_zone_name      = data.terraform_remote_state.vpc.outputs.zone["private"]["name"]
    public_zone_id          = data.terraform_remote_state.vpc.outputs.zone["public"]["id"]
    public_zone_name        = data.terraform_remote_state.vpc.outputs.zone["public"]["name"]
    app_name                = "jira"
    jira_data_volume_id     = local.efs["id"]
    jira_data_dns_name      = local.efs["dns_name"]
    jira_db_endpoint        = local.rds_cluster["endpoint"]
    jira_db_master_username = local.rds_cluster["master_username"]
    //dns_name                = "service2" # for dev
    dns_name         = var.environment_name == "cr-jira-prod" ? "service" : "service2" #to bootstrap prod
    name             = "${var.environment_name}-ec2"
    public_ssl_arn   = data.terraform_remote_state.vpc.outputs.strategic_public_ssl_arn[0]
    ssh_deployer_key = data.terraform_remote_state.vpc.outputs.ssh_deployer_key
    vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
  }

  # var
  environment_name = var.environment_name
  tags             = var.tags

  public_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["public"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["public"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["public"],
  ]
  private_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az1"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az2"]["id"]["private"],
    data.terraform_remote_state.vpc.outputs.vpc_subnet["az3"]["id"]["private"],
  ]
  alb_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_jira_lb"],
    data.terraform_remote_state.security-groups.outputs.id["egress_from_jira_lb"]
  ]
  asg_security_groups = [
    data.terraform_remote_state.security-groups.outputs.id["ingress_to_jira"],
    data.terraform_remote_state.security-groups.outputs.id["egress_from_jira"]
  ]


  jira_conf = {
    login_duration              = "28800"
    jira_db_driver              = "org.postgresql.Driver"
    jira_db_type                = "postgresaurora96"
    sharedhome_path             = "/var/atlassian/application-data/jira"
    shared_home_volume_name     = "jira_shared_home"
    shared_home_volume_root_dir = "/jira_shared_home"
    jira_config_path            = "/opt/atlassian/jira/conf"
    jira_config_volume_name     = "jira_config"
    jira_config_volume_root_dir = "/jira_config"
    jira_type                   = "jira-ec2"
    instance_type               = "m5.large"
    log_retention               = 14
    image_id                    = data.aws_ami.latest_ecs.id
  }
}
