
# Things you need to configure.

# RDS - postgres
# networking - consist of subnets, sg , route table , nacls 
# ssh - keypair
# instance - ec2 instance with userdata
# redis 


module "networking" {
    source = "./modules/networking"
    namespace = var.namespace
    public_cidr_block = "10.0.1.0/24" 
    private_cidr_block_2 = "10.0.3.0/24"
    private_cidr_block_1 = "10.0.2.0/24"
    default_cidr_vpc = "10.0.0.0/16"
}

module "server" {
    source = "./modules/server"
    namespace = var.namespace
    public_subnet_id = module.networking.public_subnet_id
    public_sg_id = module.networking.public_sg_id
}

module "rds" {
    source = "./modules/rds"
    db_name = var.db_name
    db_user = var.db_user
    db_password = var.db_password
    postgres_sg_id = module.networking.postgres_sg_id
    private_subnet_1 = module.networking.private1_subnet_id
    private_subnet_2 = module.networking.private2_subnet_id
}

module "redis" {
    source = "./modules/redis"
    private_subnet_2 = module.networking.private2_subnet_id
    redis_sg_id = module.networking.redis_sg_id
}
