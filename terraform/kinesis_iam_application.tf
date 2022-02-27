# Defines IAM resources for the Kinesis application

# First a role
# Specifies which type of resource assumes that role (who has that role)
resource "aws_iam_role" "kinesis_analytics_sql_streaming_application" {
  name = "kinesis-analytics-sql-streaming-application"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "kinesisanalytics.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Environment = "test"
  }
}

# Then one or more policies which state permissions on specific ressources
# This is a fine grained custom policy (inline policy)
# Replace placeholders with the ARN of the target resource (ex ARN of the input data stream)
resource "aws_iam_role_policy" "kinesis_data_stream_read_access" {
  name = "data-stream-read-access"
  role = aws_iam_role.kinesis_analytics_sql_streaming_application.id

  # Read data from the datastream: ReadInputKinesis policy
  # Write data to the delivery stream: WriteOutputFirehose policy
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadInputKinesis",
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords"
            ],
            "Resource": [
                "${aws_kinesis_stream.kinesis-input-meteo.arn}"
            ]
        },
        {
            "Sid": "WriteOutputKinesis",
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:PutRecord",
                "kinesis:PutRecords"
            ],
            "Resource": [
                "arn:aws:kinesis:region:account-id:stream/%STREAM_NAME_PLACEHOLDER%"
            ]
        },
        {
            "Sid": "WriteOutputFirehose",
            "Effect": "Allow",
            "Action": [
                "firehose:DescribeDeliveryStream",
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": [
                "${aws_kinesis_firehose_delivery_stream.s3_destination_delivery_meteo.arn}"
            ]
        },
        {
            "Sid": "ReadInputFirehose",
            "Effect": "Allow",
            "Action": [
                "firehose:DescribeDeliveryStream",
                "firehose:Get*"
            ],
            "Resource": [
                "arn:aws:firehose:region:account-id:deliverystream/%FIREHOSE_NAME_PLACEHOLDER%"
            ]
        },
        {
            "Sid": "ReadS3ReferenceData",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::kinesis-analytics-placeholder-s3-bucket/kinesis-analytics-placeholder-s3-object"
            ]
        },
        {
            "Sid": "ReadEncryptedInputKinesisStream",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:region:account-id:key/%SOURCE_STREAM_ENCRYPTION_KEY_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.us-east-1.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:us-east-1:917184364479:stream/input-stream"
                }
            }
        },
        {
            "Sid": "WriteEncryptedOutputKinesisStream1",
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "arn:aws:kms:region:account-id:key/%DESTINATION_STREAM_ENCRYPTION_KEY_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.us-east-1.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:region:account-id:stream/%STREAM_NAME_PLACEHOLDER%"
                }
            }
        },
        {
            "Sid": "WriteEncryptedOutputKinesisStream2",
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "arn:aws:kms:region:account-id:key/%DESTINATION_STREAM_ENCRYPTION_KEY_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.us-east-1.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:region:account-id:stream/%STREAM_NAME_PLACEHOLDER%"
                }
            }
        },
        {
            "Sid": "WriteEncryptedOutputKinesisStream3",
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "arn:aws:kms:region:account-id:key/%DESTINATION_STREAM_ENCRYPTION_KEY_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.us-east-1.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:region:account-id:stream/%STREAM_NAME_PLACEHOLDER%"
                }
            }
        },
        {
            "Sid": "UseLambdaFunction",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:GetFunctionConfiguration"
            ],
            "Resource": [
                "arn:aws:lambda:region:account-id:function:%FUNCTION_NAME_PLACEHOLDER%:%FUNCTION_VERSION_PLACEHOLDER%"
            ]
        }
    ]
}
EOF

}
