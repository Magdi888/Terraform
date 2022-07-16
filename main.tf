module "network" {
    source = "./network"
    vpc_cidr = var.vpc_cidr
    public_subnet-1_cidr = var.public_subnet1_cidr
    public_subnet-2_cidr = var.public_subnet2_cidr
    private_subnet-1_cidr = var.private_subnet1_cidr
    private_subnet-2_cidr = var.private_subnet2_cidr
    region = var.region
}