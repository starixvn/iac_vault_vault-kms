module "vaul_autounseal_policy_v1" {
  source  = "gitlab.nexdev.net/iac/aws-iam/aws//modules/iam-policy"
  version = "5.17.1"

  name        = lower("${var.team}-${var.environment}-vault-auto-unseal-v1")
  path        = "/"
  description = "Managed by vnTerraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VolumeEncryption",
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  tags = local.common_tags
}

###############
module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description = "Auto unSeal for Vault"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  #key_administrators                 = ["arn:aws:iam::584102114761:policy/lumi-local-vault-auto-unseal-v1"]
  #key_service_roles_for_autoscaling  = ["arn:aws:iam::012345678901:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  #key_service_users                 = ["arn:aws:iam::584102114761:policy/lumi-local-vault-auto-unseal-v1"]
  key_users = ["arn:aws:iam::${var.aws_account_id}:user/vault-unseal"]

  # Aliases
  aliases = ["${var.environment}_vault_unseal_key"]

  tags = local.common_tags
}