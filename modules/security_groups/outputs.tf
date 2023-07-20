output "alb-sg-id" {
    value = aws_security_group.alb-sg.id
}

output "web-server-sg-id" {
    value = aws_security_group.web-server-sg.id
}