resource "aws_instance" "ecs_instance" {
  ami                         = "ami-040a7dcfd701fead5"
  instance_type               = "t2.small"
  monitoring                  = true
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.name
  subnet_id                   = aws_subnet.public_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs.id]
  key_name                    = "mykey"

  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.prefix}-ecs-instance"
  }

  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=kurashinolog >> /etc/ecs/ecs.config
EOF
}
