output "managed_repositories" {
  description = "List of managed repositories"
  value       = [for repo in module.repositories : repo.name]
}

output "governed_apps_count" {
  description = "Total number of governed applications"
  value       = module.app_governance.governed_apps_count
}

output "granted_access_count" {
  description = "Total number of app-to-repo access bindings"
  value       = module.app_governance.granted_access_count
}

output "app_access_matrix" {
  description = "Overview of which apps have access to which repositories"
  value       = module.app_governance.access_matrix
}
