# fixed vars that will be reused frequently
locals {

  #default tags. can use the merge() function on resource to add arbitrary additional tags
  default_tags = {
    managed_by   = "Terraform"
    owner        = "DevOps"
    project_name = var.project_name
    environment  = var.environment
  }
}