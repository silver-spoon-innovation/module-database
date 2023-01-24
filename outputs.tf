output "project_name" {
	value = mongodbatlas_project.project.name
}
output "user1" {
	value = mongodbatlas_database_user.user.username
}
output "ipaccesslist" {
  	value = mongodbatlas_project_ip_access_list.ip.ip_address
}
output "connection_strings" {
  	value = mongodbatlas_cluster.cluster.connection_strings[0].standard_srv
}
# output "plstring" {
#   value = lookup(mongodbatlas_cluster.cluster.connection_strings[0].aws_private_link_srv, aws_vpc_endpoint.ptfe_service.id)
# }