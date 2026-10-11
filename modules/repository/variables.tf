variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "description" {
  description = "A description of the repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Visibility of the repository (public, private, internal)"
  type        = string
  default     = "private"
}

variable "has_issues" {
  description = "Enable GitHub Issues"
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Enable GitHub Wiki"
  type        = bool
  default     = false
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches when pull requests are merged"
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = false
}

variable "allow_squash_merge" {
  description = "Allow squash merging"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging"
  type        = bool
  default     = false
}

variable "topics" {
  description = "List of topics/tags for the repository"
  type        = list(string)
  default     = []
}

variable "enforce_branch_protection" {
  description = "Whether to configure branch protection for the default branch"
  type        = bool
  default     = false
}

variable "branch_protection_branch" {
  description = "The target branch pattern for branch protection"
  type        = string
  default     = "main"
}

variable "required_approving_review_count" {
  description = "Number of required approving reviews on pull requests"
  type        = number
  default     = 1
}
