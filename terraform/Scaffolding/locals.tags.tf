# Licensed under the MIT License.

locals {
  default_tags = {
    deployedBy  = format("AzureNoOpsTF [%s]", terraform.workspace)
    environment = var.environment
    workload    = var.workload_name
  } 
}