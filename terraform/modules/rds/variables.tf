variable "db_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "db_name" {
  type = string
  default = "appdb"
}

variable "db_username" {
  type = string
  default = "appuser"
}

variable "db_password" {
  type = string
  default = "AppSecurePass123"
}
