variable "existing_asset_model_id" {
  description = "If set, Terraform will use this existing SiteWise asset model id instead of creating a new one. Leave empty to create a new model."
  type        = string
  default     = ""
}

variable "existing_asset_id" {
  description = "If set, Terraform will use this existing SiteWise asset id instead of creating a new asset. Leave empty to create a new asset."
  type        = string
  default     = ""
}
