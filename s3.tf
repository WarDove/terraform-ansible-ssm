resource "aws_s3_bucket" "main" {
  bucket = "ansible-bucket-4-demo"

  tags = merge({
    Name = "ansible-bucket-4-demo",
  }, local.default_tags)
}