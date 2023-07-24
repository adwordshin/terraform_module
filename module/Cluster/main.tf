### Seoul Center VPC EKS Cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster-name
  role_arn = data.aws_iam_role.cluster-role.arn

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids = [data.aws_security_group.cluster-sg.id]
    subnet_ids         = [
	  data.aws_subnet.pvt-2a-name.id,
	  data.aws_subnet.pvt-2c-name.id
	]
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    data.aws_iam_role_policy.AmazonEKSClusterPolicy,
    data.aws_iam_role_policy.AmazonEKSVPCResourceController
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}


### role for OIDC & CNI role
data "tls_certificate" "eks-cluster-tls-certificate" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks-cluster-aws-iam-openid-connect-provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-cluster-tls-certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eks-cluster-aws-iam-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-cluster-aws-iam-openid-connect-provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-cluster-aws-iam-openid-connect-provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks-cluster-vpc-cni-role" {
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-aws-iam-policy-document.json
  name               = "eks-cluster-vpc-cni-role"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-vpc-cni-role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-cluster-vpc-cni-role.name
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}
