output "atlas_cluster_connection_string" {
	value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv
}

output "ip_access_list" {
	value = mongodbatlas_project_ip_access_list.ip.ip_address
}

output "project_name" {
	value = mongodbatlas_project.atlas-project.name
}

output "username" {
	value = mongodbatlas_database_user.db-user.username
}

output "user_password" {
	sensitive = true
	value = mongodbatlas_database_user.db-user.password
}

data "mongodbatlas_advanced_cluster" "atlas-cluser" {
  project_id = mongodbatlas_project.atlas-project.id
  name       = mongodbatlas_advanced_cluster.atlas-cluster.name
  depends_on = [mongodbatlas_privatelink_endpoint_service.atlaseplink]
}

output "privatelink_connection_string" {
  value = lookup(mongodbatlas_advanced_cluster.atlas-cluster.connection_strings[0].aws_private_link_srv, aws_vpc_endpoint.ptfe_service.id)
}