resource "mongodbatlas_project" "project" {
	name   = var.project_name
	org_id = var.org_id
}

# Create a Database User
resource "mongodbatlas_database_user" "user" {
	username           = var.dbuser
	password           = var.dbuser
	project_id         = mongodbatlas_project.project.id
	auth_database_name = "admin"

	roles {
		role_name     = "readWrite"
		database_name = "${var.project_name}"
	}
	labels {
		key   = "Name"
		value = "DB User1"
	}
}

# Create Database IP Access List
resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.project.id
  cidr_block = var.cidr_block
}

# Create an Atlas Advanced Cluster
resource "mongodbatlas_cluster" "cluster" {
  project_id             = mongodbatlas_project.project.id
  name                   = "${var.project_name}-${var.environment}-cluster"
  mongo_db_major_version = var.mongodbversion
  cluster_type           = "REPLICASET"

  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = var.region
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  # Provider Settings "block"
  cloud_backup                 = true
  auto_scaling_disk_gb_enabled = true
  provider_name                = "TENANT"
  backing_provider_name        = var.cloud_provider   
  provider_instance_size_name  = var.cluster_instance_size_name
}

# resource "mongodbatlas_privatelink_endpoint" "atlaspl" {
#   project_id    = mongodbatlas_project.project.id
#   provider_name = var.cloud_provider
#   region        = var.aws_region
# }

# resource "aws_security_group" "ptfe_service" {
#   vpc_id      = var.vpc_id
#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "tcp"
#     cidr_blocks = [
#       "0.0.0.0/0",
#     ]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_vpc_endpoint" "ptfe_service" {
#   vpc_id             = var.vpc_id
#   service_name       = mongodbatlas_privatelink_endpoint.atlaspl.endpoint_service_name
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = var.aws_private_subnet_ids
#   security_group_ids = [aws_security_group.ptfe_service.id]
# }

# resource "mongodbatlas_privatelink_endpoint_service" "atlaseplink" {
#   project_id          = mongodbatlas_privatelink_endpoint.atlaspl.project_id
#   endpoint_service_id = aws_vpc_endpoint.ptfe_service.id
#   private_link_id     = mongodbatlas_privatelink_endpoint.atlaspl.id
#   provider_name       = var.cloud_provider
# }

# data "aws_route53_zone" "private-zone" {
# 	zone_id      = var.route53_id
# 	private_zone = true
# }

# resource "aws_route53_record" "ptfe_service" {
# 	zone_id = var.route53_id
# 	name    = "ptfe.${data.aws_route53_zone.private-zone.name}"
# 	type    = "CNAME"
# 	ttl     = "300"
# 	records = [aws_vpc_endpoint.ptfe_service.dns_entry[0]["dns_name"]]
# }


