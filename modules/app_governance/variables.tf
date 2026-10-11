variable "apps" {
  description = "Registry of GitHub Apps to govern with metadata and repository assignments"
  type = map(object({
    installation_id = string
    owner           = string
    purpose         = string
    risk_level      = string
    review_cycle    = string
    expiry_date     = string
    repositories    = list(string)
  }))
}
