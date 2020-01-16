output "auth_client_private_key" {
  sensitive = true
  value     = tls_private_key.client.private_key_pem
}

output "auth_client_certificate" {
  sensitive = true
  value     = tls_locally_signed_cert.client.cert_pem
}

