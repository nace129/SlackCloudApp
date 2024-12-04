resource "aws_ecs_cluster" "app_cluster" {
  name = "slack-app-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "slack-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "frontend-container",
      image     = "588738575824.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest", 
      cpu       = 256,
      memory    = 512,
      essential = true,
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    },
    {
      name      = "backend-container"
      image     = "588738575824.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest" 
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "app_service" {
  name            = "slack-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public_subnet_1.id]
    security_groups = [aws_security_group.app_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "frontend-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.app_listener]
}


#Extra
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    # policy_arn = aws_iam_role.ecs_task_execution_role.assume_role_policy.arn
}

output "aws_ecs_cluster" {
  value = aws_ecs_cluster.app_cluster.name
}

output "aws_ecs_service" {
  value = aws_ecs_service.app_service.name
}