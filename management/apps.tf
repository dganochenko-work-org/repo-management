module "app_governance" {
  source = "../modules/app_governance"

  apps = var.apps

  depends_on = [module.repositories]
}
