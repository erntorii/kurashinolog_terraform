resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
}

resource "aws_ecs_service" "app-service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.http.arn
    container_name   = "app"
    container_port   = "3000"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "app-task" {
  family                = "app-task"
  cpu                   = "512"
  memory                = "512"
  container_definitions = file("./container_definitions.json")
  network_mode          = "bridge"
  execution_role_arn    = module.ecs_task_role.iam_role_arn

  volume {
    name = "sockets"

    docker_volume_configuration {
      scope  = "task"
      driver = "local"
    }
  }
  volume {
    name = "public-data"

    docker_volume_configuration {
      scope  = "task"
      driver = "local"
    }
  }
}
