output "access_matrix" {
  description = "Matrix of all GitHub App installation permissions across repositories"
  value = {
    for item in local.app_repo_pairs : item.key => {
      app             = item.app_key
      repository      = item.repository
      installation_id = item.installation_id
      owner           = var.apps[item.app_key].owner
      risk_level      = var.apps[item.app_key].risk_level
      expiry_date     = var.apps[item.app_key].expiry_date
    }
  }
}

output "governed_apps_count" {
  description = "Total number of governed applications"
  value       = length(var.apps)
}

output "granted_access_count" {
  description = "Total number of app-to-repository access bindings"
  value       = length(local.app_repo_pairs)
}
