variable "region" {
  type    = string
  default = "us-east-1"
}

variable "s3_bucket_name" {
  type    = string
  default = "ror-app-upload-prasath"
}

variable "ecr_repo_name" {
  type    = string
  default = "ror-app"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type    = string
  default = "AppSecurePass123"
}

variable "app_image_url" {
  type = string
  description = "ECR image URL"
}