terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "openstack" {
  user_name   = "{{USER_NAME}}"
  password    = "{{PASSWORD}}"
  auth_url    = "{{AUTH_URL}}"
  region      = "{{REGION}}"
  tenant_name = var.openstack_tenant_name
}
