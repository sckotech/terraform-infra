
variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ami" {
  type    = string
  default = "ami-085925f297f89fce1"
}


variable "public-subnet-cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private-subnet-cidr" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

