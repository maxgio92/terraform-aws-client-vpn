# AWS Client VPN managed via Terraform

This Terraform module manages an AWS Client VPN with mutual authentication.

It creates and manages:

- Client authentication's keypair and certificate
- Server authentication's keypair and certificate
- Client VPN endpoint
- Client VPN target network associations

It requires:
- CA's certificate
- CA's private key

Post-apply required steps:
- Authorization ingress
- OpenVPN client config file download
- OpenVPN client config file update with client private key and certificate \*

\* They can retrieved from the module outputs.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| auth\_ca\_cert\_pem | n/a | `any` | n/a | yes |
| auth\_ca\_private\_key\_pem | n/a | `any` | n/a | yes |
| auth\_client\_certificate\_common\_name | The FQDN of the client certificate for the VPN Client   mutual authentication | `any` | n/a | yes |
| auth\_client\_certificate\_organization | The organization name of the client certificate   for the VPN Clients mutual authentication" | `string` | `"client"` | no |
| auth\_server\_certificate\_common\_name | The FQDN of the server certificate for the VPN Client   mutual authentication | `any` | n/a | yes |
| auth\_server\_certificate\_organization | The organization name of the server certificate   for the VPN Clients mutual authentication" | `string` | `"server"` | no |
| custom\_tags | A map of custom tags to apply to all resources | `map(string)` | `{}` | no |
| default\_tags | A map of default tags to apply to all resources | `map(string)` | <code><pre>{<br>  "Terraform": "true"<br>}<br></pre></code> | no |
| split\_tunnel | n/a | `bool` | `true` | no |
| target\_network\_association\_subnet\_ids | A list of one or more networks (VPC subnets) that you associate with a Client   VPN endpoint. Associating a subnet with a Client VPN endpoint enables   you to establish VPN sessions. All subnets must be from the same VPC.    Each subnet must belong to a different Availability Zone | `list(string)` | n/a | yes |
| vpn\_cidr | The IPv4 address range, in CIDR notation, from which to   assign client IP addresses. The address range cannot overlap   with the local CIDR of the VPC in which the associated subnet   is located, or the routes that you add manually. The address   range cannot be changed after the Client VPN endpoint has been   created. The CIDR block should be /22 or greater. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| auth\_client\_certificate | n/a |
| auth\_client\_private\_key | n/a |

