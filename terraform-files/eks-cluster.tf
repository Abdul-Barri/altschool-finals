# Create EKS Cluster

resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-cluster-portfolio"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks-security-group.id]
    subnet_ids = [aws_subnet.pub-sub1.id, aws_subnet.pub-sub2.id, aws_subnet.pub-sub3.id, aws_subnet.priv-sub1.id, aws_subnet.priv-sub2.id, aws_subnet.priv-sub3.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

# Create EKS Cluster node group

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks-nodes-role.arn
  instance_types = ["t2.micro"]
  subnet_ids      = [aws_subnet.pub-sub1.id, aws_subnet.pub-sub2.id, aws_subnet.pub-sub3.id, aws_subnet.priv-sub1.id, aws_subnet.priv-sub2.id, aws_subnet.priv-sub3.id]

  scaling_config {
    desired_size = 4
    max_size     = 6
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}
