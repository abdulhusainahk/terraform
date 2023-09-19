
resource "aws_cloudfront_distribution" "s3_distribution" {
  aliases = [
    "${var.cf_alias}.${var.envdns}.${domain}.com"
  ]
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = var.price_class
  retain_on_delete    = false
  tags                = {}
  tags_all            = {}
  wait_for_deployment = false
  web_acl_id          = var.web_acl_id
  default_root_object = "index.html"
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = var.cloudfront_default_ttl
    max_ttl                = var.cloudfront_max_ttl
    min_ttl                = var.cloudfront_min_ttl
    smooth_streaming       = false
    target_origin_id       = "${var.bucket-name}.s3.us-east-1.amazonaws.com"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = []
      query_string            = false
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "${var.bucket-name}.s3.us-east-1.amazonaws.com"
    origin_id           = "${var.bucket-name}.s3.us-east-1.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arncf
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }


  enabled = true
}


resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.bucket-name}.s3.${var.aws_region}.amazonaws.com"
}

