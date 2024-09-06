#############################################################
#############################################################
module "iam_assumable_role_vault_trust_policy_v1" {
  source      = "gitlab.nexdev.net/iac/aws-iam/aws//modules/iam-assumable-role"
  version     = "5.17.1"
  create_role = true
  create_instance_profile = true
  role_name = lower("${var.team}-${var.environment}-vault-Role-v1")

  custom_role_trust_policy = data.aws_iam_policy_document.custom_trust_vault_v1.json
  custom_role_policy_arns  = ["${module.iam_policy_vault_v1.arn}"]
  tags                     = local.common_tags
}

data "aws_iam_policy_document" "custom_trust_vault_v1" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:user/vault-unseal"]
    }
  }
}


module "iam_policy_vault_v1" {
  source  = "gitlab.nexdev.net/iac/aws-iam/aws//modules/iam-policy"
  version = "5.17.1"

  name        = lower("${var.team}-${var.environment}-vault-v1")
  path        = "/"
  description = "Managed by vnTerraform"
  policy = <<EOF
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachUserPolicy",
                "iam:CreateAccessKey",
                "iam:CreateUser",
                "iam:DeleteAccessKey",
                "iam:DeleteUser",
                "iam:DeleteUserPolicy",
                "iam:DetachUserPolicy",
                "iam:ListAccessKeys",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroupsForUser",
                "iam:ListUserPolicies",
                "iam:PutUserPolicy",
                "iam:AddUserToGroup",
                "iam:RemoveUserFromGroup",
                "s3:*",
                "ec2:*",
                "rds:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF

  tags = local.common_tags
}

