module "repositories" {
  source   = "../modules/repository"
  for_each = var.repositories

  name                            = each.key
  description                     = each.value.description
  visibility                      = each.value.visibility
  has_issues                      = each.value.has_issues
  has_wiki                        = each.value.has_wiki
  delete_branch_on_merge          = each.value.delete_branch_on_merge
  allow_merge_commit              = each.value.allow_merge_commit
  allow_squash_merge              = each.value.allow_squash_merge
  allow_rebase_merge              = each.value.allow_rebase_merge
  vulnerability_alerts            = each.value.vulnerability_alerts
  topics                          = each.value.topics
  enforce_branch_protection       = each.value.enforce_branch_protection
  branch_protection_branch        = each.value.branch_protection_branch
  required_approving_review_count = each.value.required_approving_review_count
}
