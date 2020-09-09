resource "aws_iam_user" "deploy-user" {
  name = "${var.prefix}-deploy-user"
}

data "aws_iam_policy" "ecr-power-user" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_policy" "deploy" {
  name   = "${var.prefix}-deploy"
  policy = data.aws_iam_policy.ecr-power-user.policy
}

resource "aws_iam_user_policy_attachment" "deploy-attach" {
  user       = aws_iam_user.deploy-user.name
  policy_arn = aws_iam_policy.deploy.arn
}
