#AWS Security Group Creation
resource "aws_security_group" "jenkins_securitygroup" {
  name        = "jenkins_securitygroup"
  description = "Jenkins security group"
  #ssh
  ingress {
    description = "ssh from IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #all access on port 8080
  ingress {
    description = "http proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   #all access on port 80
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "jenkins_securitygroup"
  }
}

#Configure the AWS Provider
provider "aws" {
  region  = "us-west-2"
}

#Create EC2 Instance
resource "aws_instance" "jenkinsinstance1" {
  ami           = "ami-0efa651876de2a5ce"
  instance_type = "t2.micro"
  tags = {
    Name = "Jenkins_instance"
  }
  
#Bootstrap Jenkins installation and start  
  user_data = <<-EOF

#!/bin/bash
#update all packages
sudo yum update -y

#Get latest updates
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

#Install Java and Jenkins
sudo amazon-linux-extras install java-openjdk11 -y && sudo yum install jenkins -y

#Enable and Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
EOF

 user_data_replace_on_change = true
}

#Create Private S3 Bucket for Jenkins Artifacts 
resource "aws_s3_bucket" "my-terraform-cbeezy4-bucket" {
  bucket = "my-terraform-cbeezy4-bucket"

tags = {
    Name        = "jenkins_artifacts"
    Environment = "Dev"
  }
}
#Make S3 Bucket Private
resource "aws_s3_bucket_acl" "private_bucket" {
  bucket = aws_s3_bucket.my-terraform-cbeezy4-bucket.id
  acl    = "private"
}
