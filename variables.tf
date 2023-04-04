#Variable Terraform File Template
variable "subnet_id" {
    description = "The VPC subnet the instance(s) will be created in"
    default = "subnet-0e6ff64b663634d14" #default subnet
}

variable "vpc_id" {
    type = string
    default = "vpc-047329889bf567075" #default VPC ID
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_name" {
    type = string
    default = "GeneralUseKeyPair" #look in AWS console for your key name
}