

resource "aws_security_group" "ec2_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  to_port           = 80
  from_port = 80
  description = "allow http"
}


resource "aws_vpc_security_group_egress_rule" "allow_all" {
    security_group_id = aws_security_group.ec2_sg.id
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_iam_instance_profile" "api_instance_profile" {
  role = aws_iam_role.api_instance_role.name
}

resource "aws_launch_template" "api_instance_template" {

  image_id = "ami-052064a798f08f0d3"


  iam_instance_profile {
    name = aws_iam_instance_profile.api_instance_profile.name
    
  }
  
  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
  }
  
  instance_type = "t3.medium"

  user_data = base64encode(file("${path.module}/user_data.sh"))

}

resource "aws_autoscaling_group" "autoscaling_group" {
  desired_capacity           = 2
  min_size                   = 1
  max_size                   = 4
  vpc_zone_identifier        = var.ec2_subnet_ids

  launch_template {
    id      = aws_launch_template.api_instance_template.id
    version = "$Latest"
  }


}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
resource "aws_lb" "load_balancer" {
  name               = "web-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id]
  subnets            = var.lb_subnet_ids
}


resource "aws_lb_target_group" "target_group" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/health"
  }
}


resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


resource "aws_autoscaling_attachment" "asg_lb_attach" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  lb_target_group_arn  = aws_lb_target_group.target_group.arn
}



data "aws_iam_policy_document" "api_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "api_instance_role" {
  assume_role_policy = data.aws_iam_policy_document.api_instance_assume_role_policy.json
  description = "api instance role"
}



resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.api_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.api_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}


resource "aws_iam_role_policy_attachment" "sns_access" {
  role       = aws_iam_role.api_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}


resource "aws_ssm_parameter" "jwt_secret" {
  name        = "/finvault/JWT_SECRET"
  description = "JWT signing secret"
  type        = "SecureString"
  value       = var.jwt_secret
  overwrite   = true
}