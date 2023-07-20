module "vpc" {
  source           = "../modules/vpc"
  project-name     = var.project-name
  az-1             = var.az-1
  az-2             = var.az-2
  vpc-cidr         = var.vpc-cidr
  pub-subnet1-cidr = var.pub-subnet1-cidr
  pub-subnet2-cidr = var.pub-subnet2-cidr
  prv-subnet1-cidr = var.prv-subnet1-cidr
  prv-subnet2-cidr = var.prv-subnet2-cidr
}

module "nat" {
  source            = "../modules/nat"
  project-name      = var.project-name
  igw-id            = module.vpc.igw-id
  vpc-id            = module.vpc.vpc-id
  public-subnet1-id = module.vpc.pub-subnet1-id
  public-subnet2-id = module.vpc.pub-subnet2-id
  prv-subnet1-id    = module.vpc.prv-subnet1-id
  prv-subnet2-id    = module.vpc.prv-subnet2-id
}

module "security-group" {
  source       = "../modules/security_groups"
  project-name = var.project-name
  vpc-id       = module.vpc.vpc-id
}

module "alb" {
  source       = "../modules/alb"
  project-name = var.project-name
  ssl-cert-arn = var.ssl-cert-arn

  vpc-id            = module.vpc.vpc-id
  public-subnet1-id = module.vpc.pub-subnet1-id
  public-subnet2-id = module.vpc.pub-subnet2-id
  alb-sg-id         = module.security-group.alb-sg-id
}

output "alb-dns-name" {
  value = module.alb.alb-dns-name
}

module "asg" {
  source            = "../modules/asg"
  project-name      = var.project-name
  ec2-ami           = var.ec2-ami
  ec2-instance-type = var.ec2-instance-type
  ec2-keypair       = var.ec2-keypair

  web-server-sg-id = module.security-group.web-server-sg-id
  target-group-arn = module.alb.target-group-arn
  prv-subnet1-id   = module.vpc.prv-subnet1-id
  prv-subnet2-id   = module.vpc.prv-subnet2-id
}

module "route53" {
  source      = "../modules/route53"
  zone-name   = var.zone-name
  record-name = var.record-name

  alb-zone-name = module.alb.alb-zone-name
  alb-zone-id   = module.alb.alb-zone-id
}

output "url" {
  value = "=>  ${module.route53.url}"
}