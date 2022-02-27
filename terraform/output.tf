output "data_stream_arn" {
  description = "data stream arn"
  value       = aws_kinesis_stream.kinesis-input-meteo.arn
}

output "delivery_stream_arn" {
  description = "delivery stream arn"
  value       = aws_kinesis_firehose_delivery_stream.s3_destination_delivery_meteo.arn
}

output "current_region" {
  description = "current AWS region"
  value       = data.aws_region.current.name
}
