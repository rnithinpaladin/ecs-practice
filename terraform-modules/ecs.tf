resource "aws_ecs_cluster" "ecs_cluster" {
 name = "test-ecs-cluster"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
 name = "test1"

 auto_scaling_group_provider {
   auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

   managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
 }
}

resource "aws_ecs_task_definition" "backend_flask_task_definition" {
 family             = "backend-flask-deployment"
 network_mode       = "awsvpc" #Docker networking mode to use for the containers in the task
 execution_role_arn = "arn:aws:iam::${ACCOUNT_ID}:role/ecsTaskExecutionRole"
 cpu                = 256
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }
 container_definitions = jsonencode([
   {
     name      = "dockergs"
     image     = "public.ecr.aws/f9n5f1l7/dgs:latest"
     cpu       = 256
     memory    = 512
     essential = true
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       }
     ]
        environment = [
        {
            name  = "ENVIRONMENT"
            value = "dev"
        },
        {
            name  = "DB_HOST"
            value = "db.example.com"
        },
        {
            name  = "DB_PORT"
            value = "5432"
        },
        {
            name  = "DB_USER"
            value = "user"
        },
        {
            name  = "DB_PASSWORD"
            value = "password"
        }
        ]
    secrets = [
        {
            name      = "DB_PASSWORD"
            valueFrom = "arn:aws:ssm:us-east-1:${ACCOUNT_ID}:parameter/db_password"
        }
     ]
   }
 ])
}

resource "aws_ecs_service" "backend_service" {
 name            = "backend-ecs-service"
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.backend_flask_task_definition.arn
 desired_count   = 1
 
 network_configuration {
   subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
   security_groups = [aws_security_group.security_group.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }

 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.backend_tg.arn
   container_name   = "dockergs"
   container_port   = 80
 }

 depends_on = [aws_autoscaling_group.ecs_asg]
}

resource "aws_ecs_task_definition" "frontend_flask_task_definition" {
 family             = "frontend-flask-deployment"
 network_mode       = "awsvpc" #Docker networking mode to use for the containers in the task
 execution_role_arn = "arn:aws:iam::${ACCOUNT_ID}:role/ecsTaskExecutionRole"
 cpu                = 256
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }
 container_definitions = jsonencode([
   {
     name      = "dockergs"
     image     = "public.ecr.aws/f9n5f1l7/dgs:latest"
     cpu       = 256
     memory    = 512
     essential = true
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       }
     ]
        environment = [
        {
            name  = "ENVIRONMENT"
            value = "dev"
        },
        {
            name  = "DB_HOST"
            value = "db.example.com"
        },
        {
            name  = "DB_PORT"
            value = "5432"
        },
        {
            name  = "DB_USER"
            value = "user"
        },
        {
            name  = "DB_PASSWORD"
            value = "password"
        }
        ]
    secrets = [
        {
            name      = "DB_PASSWORD"
            valueFrom = "arn:aws:ssm:us-east-1:${ACCOUNT_ID}:parameter/db_password"
        }
     ]
   }
 ])
}

resource "aws_ecs_service" "frontend_service" {
 name            = "frontend-ecs-service"
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.frontend_flask_task_definition.arn
 desired_count   = 1
 
 network_configuration {
   subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
   security_groups = [aws_security_group.security_group.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }

 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.frontend_tg.arn
   container_name   = "dockergs"
   container_port   = 80
 }

 depends_on = [aws_autoscaling_group.ecs_asg]
}

resource "aws_ecs_task_definition" "react_backend_task_definition" {
 family             = "react-backend-deployment"
 network_mode       = "awsvpc" #Docker networking mode to use for the containers in the task
 execution_role_arn = "arn:aws:iam::${ACCOUNT_ID}:role/ecsTaskExecutionRole"
 cpu                = 256
 runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }
 container_definitions = jsonencode([
   {
     name      = "dockergs"
     image     = "public.ecr.aws/f9n5f1l7/dgs:latest"
     cpu       = 256
     memory    = 512
     essential = true
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       }
     ]
        environment = [
        {
            name  = "ENVIRONMENT"
            value = "dev"
        },
        {
            name  = "DB_HOST"
            value = "db.example.com"
        },
        {
            name  = "DB_PORT"
            value = "5432"
        },
        {
            name  = "DB_USER"
            value = "user"
        },
        {
            name  = "DB_PASSWORD"
            value = "password"
        }
        ]
    secrets = [
        {
            name      = "DB_PASSWORD"
            valueFrom = "arn:aws:ssm:us-east-1:${ACCOUNT_ID}:parameter/db_password"
        }
     ]
   }
 ])
}

resource "aws_ecs_service" "react_backend_service" {
 name            = "react-backend-ecs-service"
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.react_backend_task_definition.arn
 desired_count   = 1
 
 network_configuration {
   subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
   security_groups = [aws_security_group.security_group.id]
 }

 force_new_deployment = true
 placement_constraints {
   type = "distinctInstance"
 }

 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.react_backend_tg.arn
   container_name   = "dockergs"
   container_port   = 80
 }

 depends_on = [aws_autoscaling_group.ecs_asg]
}