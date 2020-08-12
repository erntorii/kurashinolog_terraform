resource "aws_ecr_repository" "app" {
  name = "app"
}

resource "aws_ecr_repository" "web" {
  name = "web"
}
