resource "aws_kinesis_stream" "kinesis-input-meteo" {
  name        = "input-meteo"
  shard_count = 1
  # The defaut retention period is 24h
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "test"
  }
}
