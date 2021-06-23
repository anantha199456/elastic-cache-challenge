output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private1_subnet_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private2_subnet_id" {
  value = aws_subnet.private_subnet_2.id
}

# output "public_sg_id" {
#   value = aws_subnet.private_subnet_2.id
# }

output "public_sg_id" {
  value = aws_security_group.sg_ec2.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}

output "redis_sg_id" {
  value = aws_security_group.redis-sg.id
}

