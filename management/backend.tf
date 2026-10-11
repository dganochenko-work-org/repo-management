terraform {
  required_version = "1.16.5"

  cloud {
    organization = "dganochenko-work-org"

    workspaces {
      name = "gh-actions-ws"
    }
  }
}
