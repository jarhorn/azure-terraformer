locals {
  files = {
    vscode_settings          = ".vscode/settings.json"
    vscode_extensions        = ".vscode/extensions.json"
    ado_pr_template          = ".azuredevops/pull_request_template.md"
    container_settings       = ".devcontainer/devcontainer.json"
    container_docker_compose = ".devcontainer/docker_compose.yml"
    git_ignore               = ".gitignore"
    pipelines_shared_base    = "pipelines/shared/base.pipeline.yml"
    pipelines_shared_vars    = "pipelines/shared/shared.vars.yml"
    pipelines_pr_pipeline    = "pipelines/pull-request/terraform-pull-request.pipeline.yml"
    pipelines_pr_vars        = "pipelines/pull-request/terraform-pull-request.vars.yml"
    pipelines_np_pipeline    = "pipelines/nonprod/terraform-apply.pipeline.yml"
    pipelines_np_vars        = "pipelines/nonprod/terraform-apply.vars.yml"
    pipelines_prod_pipeline  = "pipelines/prod/terraform-apply.pipeline.yml"
    pipelines_prod_vars      = "pipelines/prod/terraform-apply.vars.yml"
  }
}

resource "azuredevops_git_repository" "infrastructure_repo" {
  name           = "infrastructure"
  project_id     = azuredevops_project.proj.id
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "null_resource" "auto_install_extensions" {
  provisioner "local-exec" {
    command     = "az config set extension.use_dynamic_install=yes_without_prompt"
    interpreter = ["pwsh", "-Command"]
  }
}

resource "null_resource" "set_default_branch" {
  provisioner "local-exec" {
    command     = <<EOT
    set AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1
    az repos update --repository "${azuredevops_git_repository.infrastructure_repo.name}" `
    --default-branch "refs/heads/main" `
    --organization "${data.azuredevops_client_config.current.organization_url}" `
    --project "${azuredevops_project.proj.name}"
    EOT
    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [
    null_resource.auto_install_extensions,
    azuredevops_git_repository.infrastructure_repo
  ]
}

resource "azuredevops_git_repository_file" "files" {
  for_each      = local.files
  repository_id = azuredevops_git_repository.infrastructure_repo.id
  branch        = azuredevops_git_repository.infrastructure_repo.default_branch

  file                = each.value
  content             = file("./files/${each.value}")
  overwrite_on_create = true
}

# resource "null_resource" "delete_project_repo" {
#   provisioner "local-exec" {
#     command     = <<EOT
#     $env:AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1
#     $env:REPOSITORY_ID=(az repos show --repository "${azuredevops_project.proj.name}" `
#     --query "id" --project "${azuredevops_project.proj.name}" `
#     --organization "${data.azuredevops_client_config.current.organization_url}")
#     az repos delete --yes --id $env:REPOSITORY_ID --project "${azuredevops_project.proj.name}" `
#     --organization "${data.azuredevops_client_config.current.organization_url}"
#     EOT
#     interpreter = ["pwsh", "-Command"]
#   }

#   depends_on = [
#     null_resource.auto_install_extensions,
#     azuredevops_git_repository.infrastructure_repo
#   ]
# }
