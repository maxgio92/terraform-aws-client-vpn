# -----------------------------------------------------------------
# Server keypair, certificate request and locally-signed certficate
# -----------------------------------------------------------------

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = var.auth_server_certificate_common_name
    organization = var.auth_server_certificate_organization
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = var.auth_ca_private_key_pem
  ca_cert_pem        = var.auth_ca_cert_pem

  validity_period_hours = 300000

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "server" {
  private_key       = tls_private_key.server.private_key_pem
  certificate_body  = tls_locally_signed_cert.server.cert_pem
  certificate_chain = var.auth_ca_cert_pem
  tags = merge(
    var.default_tags,
    var.custom_tags,
    {
      Scope = "VPN"
      Role  = "server"
    }
  )
}

# -----------------------------------------------------------------
# Client keypair, certificate request and locally-signed certficate
# -----------------------------------------------------------------

resource "tls_private_key" "client" {
  algorithm = "RSA"
}

resource "tls_cert_request" "client" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = var.auth_client_certificate_common_name
    organization = var.auth_client_certificate_organization
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = var.auth_ca_private_key_pem
  ca_cert_pem        = var.auth_ca_cert_pem

  validity_period_hours = 300000

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "aws_acm_certificate" "client" {
  private_key       = tls_private_key.client.private_key_pem
  certificate_body  = tls_locally_signed_cert.client.cert_pem
  certificate_chain = var.auth_ca_cert_pem
  tags = merge(
    var.default_tags,
    var.custom_tags,
    {
      Scope = "VPN"
      Role  = "client"
    }
  )
}

# ------------------------------------------------------------
# AWS Client VPN
# ------------------------------------------------------------

# Endpoint

resource "aws_ec2_client_vpn_endpoint" "default" {
  description            = "terraform-clientvpn-example"
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = var.vpn_cidr

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client.arn
  }

  connection_log_options {
    enabled = false
  }

  split_tunnel = var.split_tunnel

  tags = merge(
    var.default_tags,
    var.custom_tags,
    {
      Scope = "VPN"
      Role  = "default"
    }
  )
}

# Target networks association

resource "aws_ec2_client_vpn_network_association" "default" {
  count                  = length(var.target_network_association_subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id

  subnet_id = var.target_network_association_subnet_ids[count.index]

  # Workaround to: https://github.com/terraform-providers/terraform-provider-aws/issues/7597
  lifecycle {
    ignore_changes = [subnet_id]
  }
  # No authorization rule can be automated here.
  # Please see: https://github.com/terraform-providers/terraform-provider-aws/issues/7494
  # At the moment it must be configured manually.
}

