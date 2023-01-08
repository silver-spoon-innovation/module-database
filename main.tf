resource "mongodbatlas_project" "atlas-project" {
	ord_id = var.atlas_ord_id
	name   = var.atlas_project_name
}

# Create a Database User
resource "mongodbatlas_database_user" "db-user" {
	username           = "microservices"
	password           = random_password.db-user-password.result
	project_id         = mongodbatlas_project.atlas-project.id
	auth_database_name = "admin"

	roles {
		role_name     = "readWrite"
		database_name = "${var.atlas_project_name}-db"
	}
}

# Create a Database Password
resource "random_password" "db-user-password" {
	length           = 16
	special          = true
	override_special = "_%@"
}

# Create Database IP Access List
resource "mongodbatlas_project_ip_access_list" "ip" {
	project_id = mongodbatlas_project.atlas-project.id
	ip_address = var.ip_address
}

# Create an Atlas Advanced Cluster
resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
	project_id     = mongodbatlas_project.atlas-project.id
	name           = "{var.atlas_project_name}-${var.environment}-cluster"
	cluster_type   = "REPLICASET"
	backup_enabled = true

	mongo_db_major_version = var.mongodb_version

	replication_specs {
		region_configs {
			electable_specs {
				instance_size = var.cluster_instance_size_name
				node_count    = 3
			}
			analytics_specs {
				instance_size = var.cluster_instance_size_name
				node_count    = 1
			}
			priority      = 7
			provider_name = var.cloud_provider
			region_name   = var.atlas_region
		}
	}
}

resource "mongodbatlas_privatelink_endpoint" "atlaspl" {
	project_id    = mongodbatlas_project.atlas-project.id
	provider_name = "AWS"
	region        = var.aws_region
}

resource "aws_security_group" "primary_default" {
  vpc_id      = var.vpc_id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "ptfe_service" {
	vpc_id             = var.vpc_id
	service_name       = mongodbatlas_privatelink_endpoint.atlaspl.endpoint_service_name
	vpc_endpoint_type  = "Interface"
	subnet_ids         = var.aws_subnet_ids
	security_group_ids = [aws_security_group.primary_default.id]
}

resource "mongodbatlas_privatelink_endpoint_service" "atlaseplink" {
	project_id          = mongodbatlas_privatelink_endpoint.atlaspl.project_id
	endpoint_service_id = aws_vpc_endpoint.ptfe_service.id
	private_link_id     = mongodbatlas_privatelink_endpoint.atlaspl.id
	provider_name       = "AWS"
}

data "aws_route53_zone" "private-zone" {
	zone_id      = var.route53_id
	private_zone = true
}

resource "aws_route53_record" "ptfe_service" {
	zone_id = var.route53_id
	name    = "ptfe.${data.aws_route53_zone.private-zone.name}"
	type    = "CNAME"
	ttl     = "300"
	records = [aws_vpc_endpoint.ptfe_service.dns_entry[0]["dns_name"]]
}

