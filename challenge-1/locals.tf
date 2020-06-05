# fixed vars that will be reused frequently
locals {
  # tagging strategy for resource management and cost tracking
  managed_by   = "Terraform"
  ops_owner    = "DevOps"
  project_name = "ttc" # ttc = three tier challenge
}