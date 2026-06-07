# ==============================================================================
# 1. INTER-SERVICE ACCESS DELEGATION: IAM COMPUTATION PERMISSIONS
# ==============================================================================
resource "aws_iam_role" "pipeline_role" {
  name = "IoTCoreAndS3ToSiteWiseProcessorRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = ["iot.amazonaws.com", "lambda.amazonaws.com"] }
    }]
  })
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "IoTCoreS3AndSiteWisePermissions"
  role = aws_iam_role.pipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject"]
        Resource = "${aws_s3_bucket.simulation_data.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "iotsitewise:BatchPutAssetPropertyValue",
          "iotsitewise:CreateAssetModel",
          "iotsitewise:UpdateAssetModel",
          "iotsitewise:CreateAsset",
          "iotsitewise:ListAssetModels",
          "iotsitewise:ListAssets",
          "iotsitewise:DescribeAssetModel",
          "iotsitewise:DescribeAsset"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# ==============================================================================
# 2. COMPUTE PROCESSING LAYER: UNIFIED ROUTER LAMBDA
# ==============================================================================
resource "aws_lambda_function" "orchestrator" {
  filename         = "lambda_function.zip"
  function_name    = "IoTCoreS3SiteWiseOrchestrator"
  role             = aws_iam_role.pipeline_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.11"
  timeout          = 45 # Increased timeout slightly to accommodate dynamic creations if missing
  source_code_hash = filebase64sha256("lambda_function.zip")
  # Note: ASSET_ID env variable removed since the script handles identification dynamically!
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.orchestrator.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.simulation_data.arn
}

# ==============================================================================
# 3. PIPELINE HOOK: AUTOMATING EVENTS UPON OBJECT CREATION
# ==============================================================================
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.simulation_data.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.orchestrator.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}