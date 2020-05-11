resource "aws_launch_configuration" "mypc-as-conf" {
  name_prefix   = "mypc-as-conf"
  image_id      = var.ami
  instance_type = "t2.micro"
  key_name = "terraform"
  security_groups = [aws_security_group.myvpc-sg.id]
  #vpc_security_group_ids = [aws_security_group.myvpc-sg.id]
  #vpc_classic_link_security_groups = [aws_security_group.myvpc-sg.id]
  user_data = file("httpd.sh")

  lifecycle {
    create_before_destroy = true
  }

  }

resource "aws_autoscaling_group" "myvpc-autoscaling" {
  #count = length(var.private-subnet-cidr)
  name                      = "myvpc-autoscaling"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  lifecycle {
    create_before_destroy = true
  }
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.mypc-as-conf.name
  #vpc_zone_identifier       = element(aws_subnet.private.*.id, count.index)
  vpc_zone_identifier       = aws_subnet.private.*.id
  load_balancers            = [aws_elb.elb.name]

 
}



  