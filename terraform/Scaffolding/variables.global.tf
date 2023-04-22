# Licensed under the MIT License.

###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "org_name" {
  description = "A name for the organization. "
  type        = string
}

variable "workload_name" {
  description = "A name for the workload."
  type        = string
}

variable "environment" {
  description = "Environment of Resources"
}