# Create a Kinesis firehose delivery stream to a S3 bucket to save the output of the analytics application

# Delivery stream to S3
resource "aws_kinesis_firehose_delivery_stream" "s3_destination_delivery_meteo" {
  name        = "s3-destination-delivery-meteo"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.delivery_stream_role.arn
    bucket_arn = aws_s3_bucket.meteo_destination.arn
  }

  tags = {

    Environment = "test"
  }
}
