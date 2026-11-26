variable "environment" {
  type        = string
  description = "Set by Atlantis from the workspace (nonprod)"
}

variable "project" {
  type    = string
  default = "Dugan-Infra"
}

variable "client_name" {
  type    = string
  default = "Dugan"
}

variable "openstack_tenant_name" {
  type    = string
  default = "om-Dugan"
}

variable "openstack_tenant_id" {
  type    = string
  default = "bff2d0c16e7c40629a5fe83195c64330"
}

variable "mssql_instance_flavor" {
  type        = string
  description = "dugan_tempdoppa (149 GB) + dugan_tempdoppa_analytics (31 GB) data < 200 GB"
  default     = "r5.xlarge.win"
}

variable "domain_join_username" {
  type    = string
  default = "Administrator"
}