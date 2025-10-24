

resource "aws_security_group" "ec2_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  to_port           = 80
  from_port = 80
  description = "allow http"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  to_port = 22
  from_port = 22
  description = "allow ssh"
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
  
  
  instance_type = "t3.medium"

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    mongo_url = "mongodb://${var.mongo_username}:${var.mongo_password}@${var.mongo_endpoint}/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&authMechanism=SCRAM-SHA-1",
    jwt_secret = "omar"
  }))

}

resource "aws_autoscaling_group" "autoscaling_group" {
  desired_capacity           = 2
  min_size                   = 1
  max_size                   = 4
  vpc_zone_identifier        = var.public_subnet_ids

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
  subnets            = var.public_subnet_ids
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


resource "aws_ssm_parameter" "ssm_mongodb_url" {
  name = var.ssm_mongodb_url_name
  type  = "String"
  value = "mongodb://${var.mongo_username}:${var.mongo_password}@${var.mongo_endpoint}:27017/?tryWrites=false"
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


resource "aws_iam_role_policy_attachment" "sns_access" {
  role       = aws_iam_role.api_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}
