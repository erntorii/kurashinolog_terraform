resource "aws_instance" "ecs_instance" {
  ami                         = "ami-08d175f1b493f205f"
  instance_type               = "t2.small"
  monitoring                  = true
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.name
  subnet_id                   = aws_subnet.public_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs_instance.id]

  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
  }

  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=app-cluster >> /etc/ecs/ecs.config
EOF
}
