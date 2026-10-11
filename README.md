# GitHub App Governance & Repository Management as Code

A GitOps system to manage GitHub Apps and repository settings across a GitHub organization using Terraform, HCP Terraform, and GitHub Actions.

---

## Table of Contents
1. [Problem & Solution](#problem--solution)
2. [Project Structure](#project-structure)
3. [App Configuration Reference](#app-configuration-reference)
   - [Risk Levels (`risk_level`)](#risk-levels-risk_level)
   - [Review Cycles (`review_cycle`)](#review-cycles-review_cycle)
4. [Quickstart: Run and Switch Organization](#quickstart-run-and-switch-organization)
5. [How-To Guides](#how-to-guides)
   - [Add a New Repository](#add-a-new-repository)
   - [Change App Access (Add or Remove Repos)](#change-app-access-add-or-remove-repos)
   - [Add a New GitHub App](#add-a-new-github-app)
6. [Governance Process](#governance-process)
   - [Track App Owners](#track-app-owners)
   - [Check Expiry Dates](#check-expiry-dates)
   - [Find Forgotten Apps (Shadow IT)](#find-forgotten-apps-shadow-it)
   - [Safe App Removal](#safe-app-removal)
7. [GitOps Pipeline](#gitops-pipeline)

---

## Problem & Solution

### The Problem
Organizations often have too many GitHub Apps installed:
* Nobody knows who installed them or who owns them.
* Apps often have access to all repositories instead of only needed ones.
* Engineers change access manually in the GitHub UI with no review or audit log.

### The Solution
We manage all repositories and GitHub Apps as code:
* **All access in Git:** You can see every app and repo in one file (`terraform.tfvars`).
* **Clear ownership:** Every app must have an owner, risk level, review cycle, and expiry date.
* **GitOps:** You request or change access via a Pull Request.

---

## Project Structure

```text
repo-management/
├── .github/
│   └── workflows/
│       └── terraform.yml          # GitOps: Plan on PR, Apply on Merge
├── management/                    # Main Terraform folder
│   ├── backend.tf                 # HCP Terraform cloud setup
│   ├── providers.tf               # GitHub provider
│   ├── variables.tf               # Variable definitions
│   ├── terraform.tfvars           # List of repos and apps
│   ├── main.tf                    # Uses repository module
│   ├── apps.tf                    # Uses app governance module
│   └── outputs.tf                 # Shows access matrix
├── modules/
│   ├── repository/                # Module to configure repos
│   └── app_governance/            # Module to give apps access to repos
├── .gitignore
└── README.md
```

---

## App Configuration Reference

Each application in `management/terraform.tfvars` must follow this format:

```hcl
apps = {
  "<app_name>" = {
    installation_id = "123456789"         # App installation ID (as string)
    owner           = "team@company.com"   # Team responsible for this app
    purpose         = "Why we need it"     # Short explanation
    risk_level      = "low"                # low, medium, high, or critical
    review_cycle    = "quarterly"          # monthly, quarterly, biannual, annual
    expiry_date     = "2026-12-31"         # Access expiry date (YYYY-MM-DD)
    repositories    = [                    # Repositories the app can access
      "repo-delta-dev"
    ]
  }
}
```

### Risk Levels (`risk_level`)

| Value | Permissions | How often to review | Examples |
| :--- | :--- | :--- | :--- |
| `low` | Read-only access, no code access. | Once a year | Slack bots, Jira sync |
| `medium` | Reads source code, but cannot write. | Every 6 months | Code linters, metrics tools |
| `high` | Writes code, approves PRs, or reads secrets. | Every 3 months (quarterly) | SAST tools (Codacy), Secret scanners (GitGuardian) |
| `critical` | Admin permissions or workflow access. | Every month | Deployment bots, CI release agents |

### Review Cycles (`review_cycle`)

| Value | Frequency | Used for | Action |
| :--- | :--- | :--- | :--- |
| `monthly` | Every 30 days | `critical` apps | Team must confirm they still need this app. |
| `quarterly` | Every 90 days | `high` risk apps | Standard security review. |
| `biannual` | Every 180 days | `medium` risk apps | Sanity check on app usage. |
| `annual` | Every 365 days | `low` risk apps | Check if the tool is still used. |

---

## Quickstart: Run and Switch Organization

### 1. Requirements
* Terraform CLI (`>= 1.16.5`).
* HCP Terraform account ([app.terraform.io](https://app.terraform.io)).
* GitHub Personal Access Token (Classic) with `repo` and `admin:org` scopes.

### 2. How to Switch to Another Organization
If you want to run this project for a different organization:
1. Open `management/backend.tf` and update `organization` and `workspaces`.
2. Open `management/terraform.tfvars` and set `github_org = "<YOUR_ORG>"`.

### 3. How to Run Locally
```bash
cd management

# 1. Set your tokens
export TF_TOKEN_app_terraform_io="<YOUR_HCP_TOKEN>"
export GITHUB_TOKEN="<YOUR_GITHUB_PAT>"
export TF_VAR_github_token="$GITHUB_TOKEN"

# 2. Run terraform
terraform init
terraform plan
terraform apply
```

---

## How-To Guides

### Add a New Repository

1. Add the repo to `management/terraform.tfvars`:
```hcl
repositories = {
  "repo-delta-staging" = {
    description            = "Staging environment"
    visibility             = "private"
    has_issues             = true
    delete_branch_on_merge = true
    topics                 = ["delta", "staging"]
    enforce_branch_protection = false
  }
}
```

2. **If the repo already exists in GitHub**, import it:
```bash
terraform import 'module.repositories["repo-delta-staging"].github_repository.this' repo-delta-staging
```
*(If the repo does not exist yet, `terraform apply` will create it).*

---

### Change App Access (Add or Remove Repos)

All access changes must go through a Pull Request.

#### Example: Give `gitguardian` access to `repo-delta-prod`
Edit `management/terraform.tfvars`:
```diff
   "gitguardian" = {
     installation_id = "170102865"
     ...
     repositories = [
       "repo-delta-dev",
+      "repo-delta-prod"
     ]
   }
```
Open a Pull Request. After review and merge, Terraform automatically grants access.

#### Example: Remove access
Simply delete the repository from the app's `repositories` list in `terraform.tfvars`. 
Terraform removes the access. The repository itself stays safe.

---

### Add a New GitHub App

1. Install the app in GitHub: **Organization Settings → GitHub Apps / Marketplace**.
2. **Important:** Select **"Only select repositories"** (do NOT choose "All repositories").
3. Get the **Installation ID** from the URL (the number at the end of the URL).
4. Add the app to `management/terraform.tfvars`:
```hcl
apps = {
  "snyk" = {
    installation_id = "180998877"
    owner           = "devsecops@company.com"
    purpose         = "Dependency vulnerability scanner"
    risk_level      = "high"
    review_cycle    = "quarterly"
    expiry_date     = "2026-12-31"
    repositories = [
      "repo-delta-dev"
    ]
  }
}
```
5. **If you already selected repos in the GitHub UI during install**, import them:
```bash
terraform import 'module.app_governance.github_app_installation_repository.this["snyk:repo-delta-dev"]' 180998877:repo-delta-dev
```
*(If you selected 0 repos in the UI, just run `terraform apply`).*

---

## Governance Process

Here is how we govern hundreds of apps at scale:

### 1. Track App Owners
* Every app has an `owner` email in `terraform.tfvars`.
* We protect `terraform.tfvars` with GitHub `CODEOWNERS`. Any change to app access requires approval from the security team.

### 2. Check Expiry Dates
* Every app has an `expiry_date`.
* A scheduled GitHub Actions workflow runs every week.
* If an app expires in less than 30 days, the workflow creates an issue and tags the owner.
* The owner must open a PR to extend the date or let the app expire.

### 3. Find Forgotten Apps (Shadow IT)
How to find an app that someone installed and forgot:
1. A weekly job calls the GitHub API:
   ```bash
   GET /orgs/{org}/installations
   ```
2. The script compares the installed apps with the apps in `terraform.tfvars`.
3. If an app is installed in GitHub but is NOT in `terraform.tfvars`, the job sends a Slack alert to the security team.

### 4. Safe App Removal
How to remove an app without breaking production:
1. **Warn the owner:** Tell the team 14 days before removing the app.
2. **Remove repo access:** Remove the repositories from `terraform.tfvars` in a PR. The app is still installed in GitHub, but has 0 repo permissions.
3. **Wait 7 days (Grace period):** Check if any build or developer process breaks.
4. **Uninstall app:** If nothing broke, remove the app block from `terraform.tfvars` and uninstall it from GitHub Organization Settings.

---

## GitOps Pipeline

We use GitHub Actions (`.github/workflows/terraform.yml`):
* **Pull Request:** Runs `terraform fmt -check`, `terraform init`, and `terraform plan`.
* **Merge to main:** Runs `terraform apply -auto-approve`.

### GitHub Secrets
* `TF_API_TOKEN`: HCP Terraform API token.
* `GH_PAT`: GitHub Personal Access Token (Classic) with `repo` and `admin:org` permissions.
