resource "aws_ecs_cluster" "main" {
  name = "ror-app-cluster"
}

resource "aws_security_group" "ecs" {
  name   = "ecs-service-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ror-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.ecs_task_execution_role

  container_definitions = jsonencode([
    {
      name      = "ror-app"
      image     = var.app_image_url
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "RDS_DB_NAME",       value = var.db_name },
        { name = "RDS_USERNAME",      value = var.db_user },
        { name = "RDS_PASSWORD",      value = var.db_password },
        { name = "RDS_HOSTNAME",      value = var.db_host },
        { name = "RDS_PORT",          value = "5432" },
        { name = "S3_BUCKET_NAME",    value = var.s3_bucket },
        { name = "S3_REGION_NAME",    value = var.s3_region },
        { name = "LB_ENDPOINT",       value = var.lb_endpoint }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "ror-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "ror-app"
    container_port   = 3000
  }
  depends_on = [var.alb_listener_arn]
}
