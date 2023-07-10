data "azuredevops_client_config" "current" {}
resource "random_pet" "pet" {}

resource "azuredevops_project" "proj" {
  name               = title(replace(random_pet.pet.id, "-", " "))
  description        = "Managed by Terraform"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Scrum"
}

resource "azuredevops_project_features" "proj_features" {
  features = {
    boards       = "enabled"
    repositories = "enabled"
    pipelines    = "enabled"
    artifacts    = "enabled"
    testplans    = "disabled"
  }
  project_id = azuredevops_project.proj.id
}
