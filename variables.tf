variable "sp_name" {
  type = string
}

variable "built_in_role" {
  type = string
}

variable "scope" {
  type = string
}

variable "key_vault_id" {
  type = string
  default = ""
}

variable "required_resource_access" {
  type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
  }))
  default = []
}