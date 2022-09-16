variable "openapi_config" {
  description = "The OpenAPI specification for the API"
  type        = any
  default = {
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }

  }
}

variable "endpoint_type" {
  type        = string
  description = "The type of the endpoint. One of - PUBLIC, PRIVATE, REGIONAL"
  default     = "REGIONAL"

  validation {
    condition     = contains(["EDGE", "REGIONAL", "PRIVATE"], var.endpoint_type)
    error_message = "Valid values for var: endpoint_type are (EDGE, REGIONAL, PRIVATE)."
  }
}

variable "logging_level" {
  type        = string
  description = "The logging level of the API. One of - OFF, INFO, ERROR"
  default     = "INFO"

}

variable "metrics_enabled" {
  description = "A flag to indicate whether to enable metrics collection."
  type        = bool
  default     = true
}

variable "xray_tracing_enabled" {
  description = "A flag to indicate whether to enable X-Ray tracing."
  type        = bool
  default     = false
}


variable "access_log_format" {
  description = "The format of the access log file."
  type        = string
  default     = <<EOF
  {
	"requestTime": "$context.requestTime",
	"requestId": "$context.requestId",
	"httpMethod": "$context.httpMethod",
	"path": "$context.path",
	"resourcePath": "$context.resourcePath",
	"status": $context.status,
	"responseLatency": $context.responseLatency,
  "xrayTraceId": "$context.xrayTraceId",
  "integrationRequestId": "$context.integration.requestId",
	"functionResponseStatus": "$context.integration.status",
  "integrationLatency": "$context.integration.latency",
	"integrationServiceStatus": "$context.integration.integrationStatus",
  "authorizeResultStatus": "$context.authorize.status",
	"authorizerServiceStatus": "$context.authorizer.status",
	"authorizerLatency": "$context.authorizer.latency",
	"authorizerRequestId": "$context.authorizer.requestId",
  "ip": "$context.identity.sourceIp",
	"userAgent": "$context.identity.userAgent",
	"principalId": "$context.authorizer.principalId",
	"cognitoUser": "$context.identity.cognitoIdentityId",
  "user": "$context.identity.user"
}
  EOF
}

variable "rest_api_policy" {
  description = "The IAM policy document for the API."
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "execute-api:Invoke",
      "Resource": "*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "123.123.123.123/32"
        }
      }
    }
  ]
}
EOF
}

variable "private_link_target_arns" {
  type        = list(string)
  description = "A list of target ARNs for VPC Private Link"
  default     = []
}


variable "stage_name" {
  type        = string
  default     = "name"
  description = "The name of the stage"
}
variable "api_name" {
  type        = string
  default     = "api_name"
  description = "The name of the api"
}


variable "kms_key_arn" {
  description = "kms arn of the cloud watch log group"
  type        = string
  default     = ""
}

variable "retention_in_days" {
  description = "Number of days you want to retain log events in the log group"
  type        = number
  default     = "30"
}
variable "cloudwatch_name" {
  description = "kms arn of the cloud watch log group"
  default     = "cloudwatch_api"
}








