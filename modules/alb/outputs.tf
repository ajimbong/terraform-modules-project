output "target-group-arn"{
    value = aws_lb_target_group.alb-tg.arn
}

output "alb-zone-name"{
    value = aws_lb.alb.dns_name
}

output "alb-zone-id"{
    value = aws_lb.alb.zone_id
}

output "alb-dns-name" {
  value = aws_lb.alb.dns_name
}