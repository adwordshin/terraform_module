### EKS Node group IAM Role
resource "aws_iam_role" "eks-cluster-nodes-group-role" {
  name = "eks-cluster-nodes-group-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-nodes-group-aws-eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-cluster-nodes-group-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-nodes-group-aws-eks-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-cluster-nodes-group-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-nodes-group-aws-ec2-container-registry-read-only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-cluster-nodes-group-role.name
}





### Seoul Center VPC EKS Cluster Node Group
resource "aws_eks_node_group" "eks-cluster-nodes-group" {
  cluster_name    = data.aws_eks_cluster.eks-cluster.name
  node_group_name = var.node-group-name
  node_role_arn   = aws_iam_role.eks-cluster-nodes-group-role.arn
  subnet_ids = [
    data.aws_subnet.pvt-2a-name.id,
    data.aws_subnet.pvt-2c-name.id
  ]

  remote_access {
    ec2_ssh_key = "seoul-eks-cluster-node-key"
  }

  capacity_type = var.node-group-capacity-type
  instance_types = [var.node-group-instance-types]
  disk_size = 30
  ami_type = "AL2_x86_64"

  scaling_config {
    desired_size = var.node-group-desired-size
    min_size     = var.node-group-min-size
    max_size     = var.node-group-max-size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-nodes-group-aws-eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-cluster-nodes-group-aws-eks-cni-policy,
    aws_iam_role_policy_attachment.eks-cluster-nodes-group-aws-ec2-container-registry-read-only
  ]
  
  tags = {
    Name = var.node-group-name
  }
}
