provider "aws" {
  region     = "us-east-1"   # You can change this if you’re using another region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "resume_matcher" {
  ami           = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"

  tags = {
    Name = "ResumeMatcher"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              docker run -d -p 3000:3000 lohitkk/resume-matcher:latest
              EOF
}

output "instance_public_ip" {
  value = aws_instance.resume_matcher.public_ip
}
