output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "kubeconfig_command" {
  description = "Run this to point kubectl at the cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name}"
}

output "tracker_secrets_role_arn" {
  description = "Role that the tracker-secrets service account assumes"
  value       = aws_iam_role.tracker_secrets.arn
}
