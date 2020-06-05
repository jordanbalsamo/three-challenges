variable "environment" {
  type        = string
  description = "The target environment to deploy resources into."
}

variable "location" {
  type        = string
  description = "Defines the location in which to deploy the primary resources (exc. failover resources). Arguments supported(string): <location>."
  default     = "UK South"
}

variable "failover_location" {
  type        = string
  description = "Defines the target failover location, if failover is enabled. Arguments supported(string): (e.g.) ukwest."
  default = "UK West"
}

variable "sql_server_version" {
  type        = string
  description = "Defines the SQL Server database version applied. Arguments supported(string): 2.0 / 12.0."
  default     = "12.0"
}

variable "sql_server_administrator_login" {
  type        = string
  description = "Defines the SQL Server administrator login. Arguments supported(string): <login>."
}

variable "sql_db_edition" {
  type        = string
  description = "Defines the edition of SQL database to provision. Arguments supported(string): Basic, Standard, Premium, DataWarehouse, Business, BusinessCritical, Free, GeneralPurpose, Hyperscale, Premium, PremiumRS, Standard, Stretch, System, System2, or Web."
  default     = "Basic"
}

variable "index_html" {
  type = string
  description = "Defines the index page name for the static site. Arguments supported(string): <index>."
  default = "index.html"
}

variable "error_404" {
  type = string
  description = "Defines the 404 page name for the static site. Arguments supported(string): <404>."
  default = "error_404.html"
}

variable "allow_trusted_azure_services" {
  type = bool
  description = "Defines whether to allow 'Trusted Azure Services' through the SQL Server firewalls. Arguments supported(bool): true / false."
  default = true
}