variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_target_group" {
  type = string
  default = "rails-tg"
}