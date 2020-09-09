resource "aws_db_subnet_group" "main" {
  name       = "${var.prefix}-dbsubnet"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
}
