module "vpc" {
  source  = "../../modules/vpc"

}

resource "random_string" "jwt_secret" {
  length           = 20
  special          = true
}
module "ec2" {
  source = "../../modules/ec2"
  vpc_id = module.vpc.vpc_id
  ec2_subnet_ids = module.vpc.private_subnet_ids
  lb_subnet_ids = module.vpc.public_subnet_ids
  jwt_secret = random_string.jwt_secret.result

}


module "documentDB" {
  source = "../../modules/documentdb"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "s3" {
  source = "../../modules/s3"
}

module "codepipeline" {
  source = "../../modules/codepipeline"
  artifacts_bucket_name = module.s3.artifacts_bucket_name
  autoscaling_group_name = module.ec2.autoscaling_group_name
}