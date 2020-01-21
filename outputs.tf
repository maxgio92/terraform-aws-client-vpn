output "auth_client_private_key" {
  sensitive = true
  value     = tls_private_key.client.private_key_pem
}

output "auth_client_certificate" {
  sensitive = true
  value     = tls_locally_signed_cert.client.cert_pem
}

output "target_network_associations_security_groups" {
  type  = list
  value = aws_ec2_client_vpn_network_association.default.security_groups
}
