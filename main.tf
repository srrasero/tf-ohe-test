terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36"
    }
    ohe={
    //  source ="hashicorp/random"
    //source="qaf010312.cloudcenter.corp/santander/ohe"
    source="santander.com/santander/ohe"
    version="0.1"
    }

  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
provider "ohe" {
  username_alm = var.username_alm
  password_alm = var.password_alm
  username_ohe=var.username_ohe
  password_ohe=var.password_ohe
  //token_user="d591c268c105ce4eaaec4b263cc5c56355b4f6f60e9d641be1c944e2674be7e0"
}

module "app_server" {
  source = "./modules/application"

  ec2_instance_type    = var.instance_type
  ami = "ami-07df274a488ca9195"
  tags = {
    Name = "server for web"
    Env = "dev"
  }
}

module "app_storage" {
  source = "./modules/storage/"
  bucket_name     = "tf-example-bucket"
  env = "dev"
}

resource "caas_project" "caas_project1" {
  provider=ohe

  tenant="qaf"
  requestid="118a59c7-6c40-4a37-8822-48e56a540b88"
  openshiftid=1
  projectid=0
  name="testf011pre_caas"
  displayname="test-ssnnttnf2"
  description="This is a sample project"
  environment="pre"
  members_users_admin=["n435868"]
  members_users_edit=[]
  members_users_view=[]
  members_groups_admin=[]
  members_groups_edit=[]
  members_groups_view=[]
  memory=5
  volumes_sharedgold=5
  volumes_blockgold=5
  volumes_blockplatinum=5
}

output "instanceid" {
  value = module.app_server.instanceID
}

output "caas_project" {
  value=caas_project.caas_project1
}

resource "application_resource" "alm_app2" {
  provider = ohe
  name = "pre-alm_app001"
  description = "Test app"
  business_value = "C"
  provider_company = "SGT"
  owner_company = "CCC"
  project_code = "UJDD"
  almteam = "ccc_sdi"
}

output "app2" {
  value = application_resource.alm_app2

}

