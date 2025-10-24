# module "vpc" {
#   source  = "../../modules/vpc"

# }

# module "ec2" {
#   source = "../../modules/ec2"
#   vpc_id = module.vpc.vpc_id
#   public_subnet_ids = module.vpc.public_subnet_ids
#   mongo_endpoint =  module.documentDB.endpoint
#   mongo_username = module.documentDB.username
#   mongo_password = module.documentDB.password
# }


# module "documentDB" {
#   source = "../../modules/documentdb"
#   private_subnet_ids = module.vpc.private_subnet_ids
#   vpc_id = module.vpc.vpc_id
# }

module "s3" {
  source = "../../modules/s3"
}

module "ci_cd" {
  source = "../../modules/ci-cd"
  artifacts_bucket_name = module.s3.artifacts_bucket_name
}