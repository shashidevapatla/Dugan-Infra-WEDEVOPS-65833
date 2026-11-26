resource "random_password" "local_admin" {
  length           = 24
  special          = true
  override_special = "!#%*-_=+" # no $ " ` \ : the module puts this inside a double-quoted shell string
}

resource "openstack_keymanager_secret_v1" "local_admin" {
  name                 = "ndugsql01_local_administrator"
  payload              = random_password.local_admin.result
  payload_content_type = "text/plain"
  secret_type          = "passphrase"
}
