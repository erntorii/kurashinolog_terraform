resource "aws_ecr_repository" "app" {
  name = "${var.prefix}_app"
}

resource "aws_ecr_repository" "web" {
  name = "${var.prefix}_web"
}
