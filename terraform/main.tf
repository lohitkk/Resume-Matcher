provider "aws" {
  region     = "ap-south-1"
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
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
