variable "regions" {

  type = map(string)
  default = {
    "region1" = "ap-south-1"
    "region2" = "us-east-2"
  }
}

variable "ami" {
  
  type = map(string)
  default = {
    "ap-south-1" = "ami-0cca134ec43cf708f"
    "us-east-2" = "ami-0a606d8395a538502"
  }
}

variable "access_key" {

  type = string
  default     = "AKIA56ODWEEZIASDASFGVI5BZX73"
  description = "Access key of the terraform IAM user"

}

variable "secret_key" {

  type = string
  default     = "jDB0dVB/Nm7CBfdYRcXB6ADASDCXSDASDSA678uDRfPu5aFPnX9TgNV+M5"
  description = "Secret key of the terraform IAM user"

}

variable "project" {
  
  type = string
  default     = "Zomato"
  description = "Name of the project"

}

variable "environment" {
  
  type = string
  default = "dev"
  description = "Project Environment" 
}

locals {

  image-timestamp = "${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
  image-name = "${var.project}-${var.environment}-${local.image-timestamp}"
}
