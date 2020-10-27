resource "aws_iam_user" "deploy-user" {
  name = "${var.prefix}-deploy-user"
}

variable "deploy_policies" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
}

resource "aws_iam_user_policy_attachment" "deploy-attach" {
  user       = aws_iam_user.deploy-user.name
  count      = length(var.deploy_policies)
  policy_arn = var.deploy_policies[count.index]
}
