github_org = "dganochenko-work-org"

repositories = {
  "repo-delta-dev" = {
    description            = "Development environment repository for Delta services"
    visibility             = "private"
    delete_branch_on_merge = true
    topics                 = ["delta", "dev", "microservices"]
    # Set true on public repos
    enforce_branch_protection = false
  }

  "repo-delta-prod" = {
    description               = "Production environment repository for Delta services"
    visibility                = "private"
    delete_branch_on_merge    = true
    topics                    = ["delta", "prod", "microservices"]
    enforce_branch_protection = false
  }
}

apps = {
  "codacy" = {
    installation_id = "170103256"
    owner           = "appsec-team@delta.com"
    purpose         = "Automated code quality & static application security testing (SAST)"
    risk_level      = "medium"
    review_cycle    = "quarterly"
    expiry_date     = "2026-12-31"
    repositories = [
      "repo-delta-dev",
      "repo-delta-prod"
    ]
  }

  "gitguardian" = {
    installation_id = "170102865"
    owner           = "secops-team@delta.com"
    purpose         = "Real-time secrets detection and leak remediation"
    risk_level      = "high"
    review_cycle    = "biannual"
    expiry_date     = "2027-01-01"
    repositories = [
      "repo-delta-dev"
      # "repo-delta-prod" will be added via Pull Request to demonstrate the GitOps workflow
    ]
  }
}
