variable "org_id" {
  type        = string
  description = "MongoDB Organization ID"
}
variable "project_name" {
  type        = string
  description = "The MongoDB Atlas Project Name"
}
variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use, must be AWS, GCP or AZURE"
}
variable "region" {
  type        = string
  description = "MongoDB Atlas Cluster Region, must be a region for the provider given"
}
variable "mongodbversion" {
  type        = string
  description = "The Major MongoDB Version"
}
variable "dbuser" {
  type        = string
  description = "MongoDB Atlas Database User Name"
}
variable "ip_address" {
  type        = string
  description = "The IP address that the cluster will be accessed from, can also be a CIDR range or AWS security group"
}
variable "aws_region" {
  type        = string
}
variable "vpc_id" {
  type        = string
}
variable "aws_subnet_ids" {
  type        = list(string)
}
variable "route53_id" {
  type        = string
}
variable "environment" {
  type        = string
}
variable "cluster_instance_size_name" {
	type = string
}