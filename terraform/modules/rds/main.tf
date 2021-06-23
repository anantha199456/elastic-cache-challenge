
# Provision AWS PostgreSQL Database
resource "aws_db_instance" "challenge" {
  identifier             = "challenge-db"
  allocated_storage      = 10
  max_allocated_storage  = 100
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.3"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.acgeaws_db_subnetccdbsgn.name
  vpc_security_group_ids = [var.postgres_sg_id]
  multi_az               = false # Outside of scope of free tier
  publicly_accessible    = true
  skip_final_snapshot    = true
  apply_immediately      = true # If this is false, changes won't take effect until next maintenance window
}

resource "aws_db_subnet_group" "acgeaws_db_subnetccdbsgn" {
  name       = "aws_db_subnet"
  subnet_ids = [var.private_subnet_1,var.private_subnet_2]

  tags = {
    Name = "My DB subnet group"
  }
}