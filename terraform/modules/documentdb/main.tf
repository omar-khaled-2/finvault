resource "aws_security_group" "docdb_sg" {
  name        = "docdb-sg"
  description = "Allow access to DocumentDB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_docdb_cluster_parameter_group" "no_tls" {
  name        = "docdb-no-tls"
  family      = "docdb5.0"
  description = "Disable TLS for DocumentDB"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "docdb-subnet-group"
  subnet_ids = var.private_subnet_ids
}



resource "aws_docdb_cluster" "docdb_cluster" {
  master_username    = "omar"
  master_password    = "12345678"
  engine             = "docdb"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  db_subnet_group_name   = aws_docdb_subnet_group.docdb_subnet_group.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.no_tls.name
}


resource "aws_docdb_cluster_instance" "docdb_instance" {

  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"
}

