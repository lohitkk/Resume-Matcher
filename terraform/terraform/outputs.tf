output "public_ip" {
  value       = aws_instance.resume_matcher.public_ip
  description = "Public IP of Resume Matcher EC2 instance"
}
