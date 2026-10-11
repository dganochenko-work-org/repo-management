terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

resource "github_repository" "this" {
  name                   = var.name
  description            = var.description
  visibility             = var.visibility
  has_issues             = var.has_issues
  has_wiki               = var.has_wiki
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  topics                 = var.topics
}

resource "github_repository_vulnerability_alerts" "this" {
  count      = var.vulnerability_alerts ? 1 : 0
  repository = github_repository.this.name
}

resource "github_branch_protection" "this" {
  count          = var.enforce_branch_protection ? 1 : 0
  repository_id  = github_repository.this.name
  pattern        = var.branch_protection_branch
  enforce_admins = false

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
    required_approving_review_count = var.required_approving_review_count
  }
}
