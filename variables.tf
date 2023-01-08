variable "atlas_org_id" {
	type = string
}

variable "atlas_project_name" {
	type = string
}

variable "environment" {
	type = string
}

variable "cluster_instance_size_name" {
	type = string
}

variable "cloud_provider" {
	type = string
}

variable "atlas_region" {
	type = string
}

variable "mongodb_version" {
	type = string
}

variable "ip_address" {
	type = string
}

variable "aws_region" {
	type = string
}

variable "vpc_id" {
	type = string
}

variable "aws_subnet_ids" {
	type = list(string)
}

variable "route53_id" {
	type = string
}