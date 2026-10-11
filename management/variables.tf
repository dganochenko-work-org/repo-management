variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "dganochenko-work-org"
}

variable "github_token" {
  description = "GitHub Personal Access Token (PAT) with repo & admin:org permissions"
  type        = string
  sensitive   = true
  default     = null
}

variable "repositories" {
  description = "Map of repositories to manage and their baseline configurations"
  type = map(object({
    description                     = optional(string, "")
    visibility                      = optional(string, "private")
    has_issues                      = optional(bool, true)
    has_wiki                        = optional(bool, false)
    delete_branch_on_merge          = optional(bool, true)
    allow_merge_commit              = optional(bool, false)
    allow_squash_merge              = optional(bool, true)
    allow_rebase_merge              = optional(bool, false)
    topics                          = optional(list(string), [])
    enforce_branch_protection       = optional(bool, false)
    branch_protection_branch        = optional(string, "main")
    required_approving_review_count = optional(number, 1)
  }))
}

variable "apps" {
  description = "Registry of governed GitHub Apps, owners, compliance lifecycles and assigned repositories"
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
