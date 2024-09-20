module "ecs_cluster" {
  source  = "cloudposse/ecs-cluster/aws"
  version = "0.9.0"

  namespace = var.namespace
  name      = var.app_name

  container_insights_enabled = true
  capacity_providers_fargate = true
}

module "ecr" {
  source                 = "cloudposse/ecr/aws"
  version                = "0.42.0"
  namespace              = var.namespace
  stage                  = var.stage
  name                   = "${var.app_name}-api-gateway"
  principals_full_access = [data.aws_iam_role.ecr.arn]
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.61.0"

  container_name  = "${var.app_name}-api-gateway"
  container_image = "${module.ecr.repository_url}:${var.image_version}"
}

module "ecs_alb_service_task" {
  source                    = "cloudposse/ecs-alb-service-task/aws"
  version                   = "0.76.0"
  namespace                 = var.namespace
  stage                     = var.stage
  name                      = "api-gateway"
  delimiter                 = ""
  alb_security_group        = module.vpc.vpc_default_security_group_id
  container_definition_json = module.container_definition.json_map_encoded_list
  ecs_cluster_arn           = module.ecs_cluster.arn
  launch_type               = "FARGATE"
  vpc_id                    = module.vpc.vpc_id
  security_group_ids        = [module.vpc.vpc_default_security_group_id]
  subnet_ids                = module.subnets.public_subnet_ids
  network_mode              = "awsvpc"
  desired_count             = 1
}
