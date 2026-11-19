data "aws_caller_identity" "current" {}

locals {
  oidc_host               = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  tracker_secrets_subject = "system:serviceaccount:tracker:tracker-secrets"
}

resource "aws_iam_openid_connect_provider" "eks" {
  url            = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "tracker_secrets_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:sub"
      values   = [local.tracker_secrets_subject]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tracker_secrets" {
  name               = "${var.cluster_name}-tracker-secrets"
  assume_role_policy = data.aws_iam_policy_document.tracker_secrets_trust.json
}

data "aws_iam_policy_document" "tracker_secrets_read" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:tracker/*",
    ]
  }
}

resource "aws_iam_role_policy" "tracker_secrets_read" {
  name   = "read-tracker-secrets"
  role   = aws_iam_role.tracker_secrets.id
  policy = data.aws_iam_policy_document.tracker_secrets_read.json
}
