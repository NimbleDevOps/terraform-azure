variable "resource_group_name" {
  description = "Name of the resource group"
  default = "myTFResourceGroup"
}
variable "location" {
  description = "Location of the resource group"
  default = "uksouth"
}
variable "environment" {
  description = "Name of the environment"
  default = "dev"
}
variable "team" {
  default = "devOps"
}
