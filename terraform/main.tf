provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "resume_matcher" {
  ami           = "ami-0dee22c13ea7a9a67"
  instance_type = var.instance_type

  tags = {
    Name = "ResumeMatcher"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              docker run -d -p 3000:3000 lohitkk/resume-matcher:latest
              EOF
}

output "instance_public_ip" {
  value       = aws_instance.resume_matcher.public_ip
  description = "Public IP of Resume Matcher EC2 instance"
}
