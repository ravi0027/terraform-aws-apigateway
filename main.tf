locals {
  create_rest_api_policy = var.rest_api_policy != null
  create_log_group       = var.logging_level != "OFF"
}

resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  name = var.api_name
  body = jsonencode(var.openapi_config)

  endpoint_configuration {
    types = [var.endpoint_type]
  }
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_rest_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id

  policy = var.rest_api_policy
}


resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway_rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gateway_stage" {
  deployment_id        = aws_api_gateway_deployment.api_gateway_deployment.id
  rest_api_id          = aws_api_gateway_rest_api.api_gateway_rest_api.id
  stage_name           = var.stage_name
  xray_tracing_enabled = var.xray_tracing_enabled

  dynamic "access_log_settings" {
    for_each = local.create_log_group ? [1] : []

    content {
      destination_arn = aws_cloudwatch_log_group.cloudwatch_log_group.arn
      format          = replace(var.access_log_format, "\n", "")
    }
  }
}

resource "aws_api_gateway_method_settings" "api_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.api_gateway_stage.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled = var.metrics_enabled
    logging_level   = var.logging_level
  }
}
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  retention_in_days = var.retention_in_days
   kms_key_id        = var.kms_key_arn
   name              = var.cloudwatch_name
}

