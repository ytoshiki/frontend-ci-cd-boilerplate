variable "prefix" {
  default = "ytoshi"
}

variable "project" {
  default = "ytoshi-app"
}

// CloudFront
variable "custom_error_responses" {
  type = list(object({
    error_caching_min_ttl = number
    error_code            = number
    response_code         = number
    response_page_path    = string
  }))
  description = "List of custom error responses"
  default = [
    {
      error_caching_min_ttl = 10
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]
}
