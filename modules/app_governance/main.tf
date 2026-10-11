terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

locals {
  app_repo_pairs = flatten([
    for app_key, app_data in var.apps : [
      for repo in app_data.repositories : {
        key             = "${app_key}:${repo}"
        app_key         = app_key
        installation_id = app_data.installation_id
        repository      = repo
      }
    ]
  ])
}

resource "github_app_installation_repository" "this" {
  for_each        = { for item in local.app_repo_pairs : item.key => item }
  installation_id = each.value.installation_id
  repository      = each.value.repository
}
