resource "aws_kinesis_analytics_application" "kinesis_sql_streaming_application" {
  name = "sql-streaming-application"

  # Define the SOURCE of the application
  inputs {
    # Prefix for the source stream name 
    name_prefix = "SOURCE_SQL_STREAM"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.kinesis-input-meteo.arn
      role_arn     = aws_iam_role.kinesis_analytics_sql_streaming_application.arn
    }

    parallelism {
      count = 1
    }

    # Schema of source data
    schema {
      record_encoding = "UTF-8"

      record_columns {
        mapping  = "$.Weather"
        name     = "description"
        sql_type = "VARCHAR(32)"
      }
      record_columns {
        mapping  = "$.wind"
        name     = "speed"
        sql_type = "REAL"
      }
      record_columns {
        mapping  = "$.temperatures"
        name     = "currentTemperature"
        sql_type = "REAL"
      }

      record_format {

        mapping_parameters {

          json {
            record_row_path = "$"
          }
        }
      }
    }

    # Starting position in the stream
    starting_position_configuration {
      starting_position = "NOW"
    }
  }

  outputs {
    name = "DESTINATION_SQL_STREAM"

    kinesis_firehose {
      resource_arn = "arn:aws:firehose:us-east-1:917184364479:deliverystream/s3-destination-delivery-meteo"
      role_arn     = "arn:aws:iam::917184364479:role/kinesis-analytics-sql-streaming-application"
    }

    schema {
      record_format_type = "JSON"
    }
  }

  # SQL code of the application 
  code = <<EOF
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (weather VARCHAR(32), speed REAL, currentTemperature REAL);

CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"

SELECT STREAM weather, speed, currentTemperature
FROM "SOURCE_SQL_STREAM_001";
EOF

  #  tags = {
  #    Environment = "test"
  #  }

  start_application = true

}
