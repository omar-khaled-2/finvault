output "endpoint" {
  value = aws_docdb_cluster.docdb_cluster.endpoint
}

output "username" {
  value = aws_docdb_cluster.docdb_cluster.master_username
}

output "password" {
  value = aws_docdb_cluster.docdb_cluster.master_password
}