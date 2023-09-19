# Module      : Api Gateway
# Description : Terraform Api Gateway module variables.
variable "enabled" {
  type        = bool
  default     = false
  description = "Whether to create rest api."
}

variable "api_gateway_name" {
  type        = string
  default     = ""
  description = "The name of the REST API "
}

variable "openapi_config" {
  type        = any
  default     = {}
  description = "The OpenAPI specification for the API"
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the REST API "
}

variable "binary_media_types" {
  type        = list(any)
  default     = ["UTF-8-encoded"]
  description = "The list of binary media types supported by the RestApi. By default, the RestApi supports only UTF-8-encoded text payloads."
}

variable "minimum_compression_size" {
  type        = number
  default     = -1
  description = "Minimum response size to compress for the REST API. Integer between -1 and 10485760 (10MB). Setting a value greater than -1 will enable compression, -1 disables compression (default)."
}

variable "api_key_source" {
  type        = string
  default     = "HEADER"
  description = "The source of the API key for requests. Valid values are HEADER (default) and AUTHORIZER."
}

variable "types" {
  type        = list(any)
  default     = ["EDGE"]
  description = "Whether to create rest api."
}

variable "vpc_endpoint_ids" {
  type        = list(string)
  default     = ["", ]
  description = "Set of VPC Endpoint identifiers. It is only supported for PRIVATE endpoint type."
}

variable "path_parts" {
  type        = list(any)
  default     = []
  description = "The last path segment of this API resource."
}

variable "status_code" {
  type        = string
  default     = "200"
  description = "The status code of the API resource"
}

variable "stage_enabled" {
  type        = bool
  default     = false
  description = "Whether to create stage for rest api."
}

# deployment 
variable "deployment_enabled" {
  type        = bool
  default     = false
  description = "Whether to deploy rest api."
}

variable "api_log_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable log for rest api."
}

variable "stage_name" {
  type        = string
  default     = ""
  description = "The name of the stage. If the specified stage already exists, it will be updated to point to the new deployment. If the stage does not exist, a new one will be created and point to this deployment."
}

variable "deploy_description" {
  type        = string
  default     = ""
  description = "The description of the deployment."
}

variable "stage_description" {
  type        = string
  default     = ""
  description = "The description of the stage."
}

variable "variables" {
  type        = map(any)
  default     = {}
  description = "A map that defines variables for the stage."
}

variable "http_method" {
  type        = string
  default     = "GET"
  description = "The http method"
}

variable "integration_http_method" {
  type        = string
  default     = "GET"
  description = "The integration http method"
}

variable "integration_type" {
  type        = string
  default     = "HTTP"
  description = "The integration method"
}

variable "uri" {
  type        = string
  default     = ""
  description = "The API uri for REST API"
}

variable "authorization" {
  type        = string
  default     = "NONE"
  description = "The authorization method"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

################################################################
# stage
variable "stage_names" {
  type        = list(any)
  default     = []
  description = "The name of the stage."
}

variable "cache_cluster_enableds" {
  type        = list(any)
  default     = []
  description = "Specifies whether a cache cluster is enabled for the stage."
}

variable "cache_cluster_sizes" {
  type        = list(any)
  default     = []
  description = "The size of the cache cluster for the stage, if enabled. Allowed values include 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118 and 237."
}

variable "client_certificate_ids" {
  type        = list(any)
  default     = []
  description = "The identifier of a client certificate for the stage"
  sensitive   = true
}

variable "descriptions" {
  type        = list(any)
  default     = []
  description = "The description of the stage."
}

variable "documentation_versions" {
  type        = list(any)
  default     = []
  description = "The version of the associated API documentation."
}

variable "stage_variables" {
  type        = list(any)
  default     = []
  description = "A map that defines the stage variables."
}

variable "xray_tracing_enabled" {
  type        = list(any)
  default     = []
  description = "A mapping of tags to assign to the resource."
}


variable "api_policy" {
  default     = null
  description = "The policy document."
}

# Cloudwatch
variable "cloudwatch_role_name" {
  type        = string
  default     = ""
  description = "The cloudwatch role name"
}

variable "retention_in_days" {
  type        = number
  description = "The retention in days"
}

variable "cloudwatch_logs_policy_name" {
  type        = string
  default     = ""
  description = "The cloudwatch policy name"
}