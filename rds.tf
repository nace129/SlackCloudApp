resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro" # Update to a supported class
#   instance_class       = "db.t2.micro"
  db_name              = "slackdb"
  username             = "dbadmin"
  password             = "UberSecretPassword" # Use Terraform variables for secrets
  publicly_accessible  = false
#   vpc_security_group_ids = [aws_security_group.app_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]
}

output "aws_db_instance" {
  value = aws_db_instance.rds_instance.db_name
}