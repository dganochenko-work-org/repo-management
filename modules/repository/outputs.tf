output "name" {
  description = "The name of the repository"
  value       = github_repository.this.name
}

output "full_name" {
  description = "Full name of the repository (org/name)"
  value       = github_repository.this.full_name
}

output "html_url" {
  description = "URL to the repository on GitHub"
  value       = github_repository.this.html_url
}
