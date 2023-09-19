variable "bucket-name" {
  type        = string
  default     = ""
  description = "Name of the bucket"
}
variable "domain" {
  default = "example"
}
variable "price_class" {
  default     = "PriceClass_100"
  description = "CloudFront distribution price class"
}

variable "use_default_domain" {
  default     = false
  description = "Use CloudFront website address without Route53 and ACM certificate"
}

variable "upload_sample_file" {
  default     = false
  description = "Upload sample html file to s3 bucket"
}

variable "cloudfront_min_ttl" {
  default     = 0
  description = "The minimum TTL for the cloudfront cache"
}

variable "cloudfront_default_ttl" {
  default     = 3600
  description = "The default TTL for the cloudfront cache"
}

variable "cloudfront_max_ttl" {
  default     = 86400
  description = "The maximum TTL for the cloudfront cache"
}


variable "acm_certificate_arncf" {

}

variable "cf_alias" {

}

variable "envdns" {

}


variable "web_acl_id" {

}

variable "aws_region" {
  default = ""
}