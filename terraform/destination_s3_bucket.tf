resource "aws_s3_bucket" "meteo_destination" {
  bucket = "meteo-destination"
  acl    = "private"

  tags = {
    Name        = "S3 bucket"
    Environment = "test"
  }
}
