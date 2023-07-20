resource "aws_launch_configuration" "launch-config" {
  name                 = "${var.project-name}-launch-config"
  image_id             = var.ec2-ami
  instance_type        = var.ec2-instance-type
  security_groups      = [var.web-server-sg-id]
  iam_instance_profile = aws_iam_instance_profile.ec2-s3-access-profile.name
  key_name = var.ec2-keypair

  user_data = <<-EOF
    #!/bin/bash 
    sudo su 
    yum update -y 
    yum install httpd -y 
    chkconfig httpd on 
    cd /var/www/html 
    aws s3 sync s3://trust-s3-website /var/www/html 
    service httpd start
  EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project-name}-asg"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  wait_for_elb_capacity     = 2

  # Attaching to target group
  target_group_arns = [var.target-group-arn]

  # Specifying the launch config
  launch_configuration = aws_launch_configuration.launch-config.name

  # Specifying the subnets
  vpc_zone_identifier = [var.prv-subnet1-id, var.prv-subnet2-id]

  tag {
    key                 = "Name"
    value               = "${var.project-name}-web-server"
    propagate_at_launch = true
  }
}