resource "azuredevops_project_permissions" "code_read_permissions" {
  permissions = {
    GENERIC_READ               = "Allow"
    VIEW_TEST_RESULTS          = "Allow"
    MANAGE_TEST_ENVIRONMENTS   = "Allow"
    MANAGE_TEST_CONFIGURATIONS = "Allow"
    DELETE_TEST_RESULTS        = "Allow"
    WORK_ITEM_DELETE           = "Allow"
    PUBLISH_TEST_RESULTS       = "Allow"
  }
  principal  = azuredevops_group.code_read.id
  project_id = azuredevops_project.proj.id
}

resource "azuredevops_tagging_permissions" "code_read_tag_permissions" {
  permissions = {
    Create = "Allow"
  }
  principal  = azuredevops_group.code_read.id
  project_id = azuredevops_project.proj.id
}

resource "azuredevops_git_permissions" "devops_git_permissions" {
  permissions = {
    PolicyExempt            = "Allow"
    PullRequestBypassPolicy = "Allow"
    CreateRepository        = "Allow"
    DeleteRepository        = "Allow"
    EditPolicies            = "Allow"
    ForcePush               = "Allow"
    RemoveOthersLocks       = "Allow"
    RenameRepository        = "Allow"
  }
  principal  = azuredevops_group.devops.id
  project_id = azuredevops_project.proj.id

}

resource "azuredevops_area_permissions" "process_admin_area_permissions" {
  permissions = {
    CREATE_CHILDREN = "Allow"
    DELETE          = "Allow"
    GENERIC_WRITE   = "Allow"
  }
  principal  = azuredevops_group.process_administrator.id
  project_id = azuredevops_project.proj.id
}

resource "azuredevops_area_permissions" "code_read_area_permissions" {
  permissions = {
    WORK_ITEM_WRITE    = "Allow"
    MANAGE_TEST_PLANS  = "Allow"
    MANAGE_TEST_SUITES = "Allow"
  }
  principal  = azuredevops_group.code_read.id
  project_id = azuredevops_project.proj.id
}

resource "azuredevops_iteration_permissions" "process_admin_iteration_permissions" {
  permissions = {
    GENERIC_READ    = "Allow"
    GENERIC_WRITE   = "Allow"
    CREATE_CHILDREN = "Allow"
    DELETE          = "Allow"
  }
  principal  = azuredevops_group.process_administrator.id
  project_id = azuredevops_project.proj.id

}
