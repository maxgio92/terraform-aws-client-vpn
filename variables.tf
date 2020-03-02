variable "vpn_cidr" {
  description = <<EOF
  The IPv4 address range, in CIDR notation, from which to
  assign client IP addresses. The address range cannot overlap
  with the local CIDR of the VPC in which the associated subnet
  is located, or the routes that you add manually. The address
  range cannot be changed after the Client VPN endpoint has been
  created. The CIDR block should be /22 or greater.
  
EOF

}

variable "target_network_association_subnet_ids" {
  type = list(string)

  description = <<EOF
  A list of one or more networks (VPC subnets) that you associate with a Client
  VPN endpoint. Associating a subnet with a Client VPN endpoint enables
  you to establish VPN sessions. All subnets must be from the same VPC. 
  Each subnet must belong to a different Availability Zone
  
EOF

}

variable "auth_server_certificate_common_name" {
  description = <<EOF
  The FQDN of the server certificate for the VPN Client
  mutual authentication
  
EOF

}

variable "auth_server_certificate_organization" {
  default = "server"

  description = <<EOF
  The organization name of the server certificate
  for the VPN Clients mutual authentication"
  
EOF

}

variable "auth_server_certificate_validity_period_hours" {
  default = 17520

  description = "The validity period in hours of the server certificate"
}

variable "auth_client_certificate_common_name" {
  description = <<EOF
  The FQDN of the client certificate for the VPN Client
  mutual authentication
  
EOF

}

variable "auth_client_certificate_organization" {
  default = "client"

  description = <<EOF
  The organization name of the client certificate
  for the VPN Clients mutual authentication"
  
EOF

}

variable "auth_client_certificate_validity_period_hours" {
  default = 17520

  description = "The validity period in hours of the client certificate"
}

variable "auth_ca_private_key_pem" {
}

variable "auth_ca_cert_pem" {
}

variable "split_tunnel" {
  default = true
}

variable "default_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
  description = "A map of default tags to apply to all resources"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "A map of custom tags to apply to all resources"
}
