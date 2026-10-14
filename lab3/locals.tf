locals {
  suffix   = "integradora-qa-mxc-001"
  location = "Mexico Central"

  tags = {
    managed_by  = "terraform"
    owner       = "it"
    cost_center = "utvt"
    Project     = "integradora"
    Environment = "qa"
    Location    = "Mexico Central"
  }
}