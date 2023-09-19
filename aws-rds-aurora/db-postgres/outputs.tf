# output "cluster_endpoint" {
#   description = "Writer endpoint for the cluster"
#   value       = try(aws_rds_cluster.gworks_cluster[0].endpoint, "")
# }

# output "cluster_reader_endpoint" {
#   description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
#   value       = try(aws_rds_cluster.gworks_cluster[0].reader_endpoint, "")
# }