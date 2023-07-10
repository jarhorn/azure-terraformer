

resource "azuredevops_build_definition" "pull_request" {
  name       = "Pull Requests"
  path       = "\\infrastructure\\${random_pet.pet.id}"
  project_id = azuredevops_project.proj.id

  repository {
    repo_id   = azuredevops_git_repository.infrastructure_repo.id
    repo_type = "TfsGit"
    yml_path  = "pipelines/pull-request/terraform-pull-request.pipeline.yml"
  }
}

resource "azuredevops_build_definition" "nonprod_apply" {
  name       = "Nonprod Apply"
  path       = "\\infrastructure\\${random_pet.pet.id}"
  project_id = azuredevops_project.proj.id

  repository {
    repo_id   = azuredevops_git_repository.infrastructure_repo.id
    repo_type = "TfsGit"
    yml_path  = "pipelines/nonprod/terraform-apply.pipeline.yml"
  }
}

resource "azuredevops_build_definition" "prod_apply" {
  name       = "Prod Apply"
  path       = "\\infrastructure\\${random_pet.pet.id}"
  project_id = azuredevops_project.proj.id

  repository {
    repo_id   = azuredevops_git_repository.infrastructure_repo.id
    repo_type = "TfsGit"
    yml_path  = "pipelines/prod/terraform-apply.pipeline.yml"
  }
}
