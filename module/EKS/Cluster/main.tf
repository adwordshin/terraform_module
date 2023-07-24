### EKS Cluster IAM Role
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-aws-eks-cluster-policy" {
  name = "eks-cluster-role-aws-eks-cluster-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-aws-eks-VPCResourceController" {
  name = "eks-cluster-role-aws-eks-VPCResourceController"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}





### Create EKS Cluster
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
    aws_iam_role_policy.eks-cluster-role-aws-eks-cluster-policy,
	aws_iam_role_policy.eks-cluster-role-aws-eks-VPCResourceController
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





### Seoul Center VPC EKS Cluster addon
resource "aws_eks_addon" "eks-cluster-vpc-cni" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "vpc-cni"
  addon_version = "v1.12.6-eksbuild.2"
  service_account_role_arn = aws_iam_role.eks-cluster-vpc-cni-role.arn
}

resource "aws_eks_addon" "eks-cluster-coredns" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name = "coredns"
  addon_version = "v1.10.1-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks-cluster-vpc-cni-role.arn
}

resource "aws_eks_addon" "eks-cluster-kube-proxy" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "kube-proxy"
  addon_version = "v1.27.1-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks-cluster-vpc-cni-role.arn
}