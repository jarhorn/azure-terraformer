resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/id_rsa"
  content  = trimspace(tls_private_key.ssh_key.private_key_pem)
}

resource "local_file" "public_key" {
  filename = "${path.module}/id_rsa.pub"
  content  = trimspace(tls_private_key.ssh_key.public_key_openssh)
}
