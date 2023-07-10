resource "azuredevops_group" "devops" {
  display_name = "DevOps"
  description  = "Individuals responsible for managing repositories, builds and artifacts of a project."
  scope        = azuredevops_project.proj.id
}

resource "azuredevops_group" "code_write" {
  display_name = "Code Write"
  description  = "Individuals responsible for code maintenance activities."
  scope        = azuredevops_project.proj.id
}

resource "azuredevops_group" "process_administrator" {
  display_name = "Process Administrator"
  description  = "Individuals reponsible for work item process maintenance activities."
  scope        = azuredevops_project.proj.id
}

resource "azuredevops_group" "code_read" {
  display_name = "Code Read"
  description  = "Individuals able to read code."
  scope        = azuredevops_project.proj.id
}

resource "azuredevops_group" "stakeholders" {
  display_name = "Stakeholders"
  description  = "Individuals interested in a project, but not involved in day-to-day activities."
  scope        = azuredevops_project.proj.id
}

data "azuredevops_group" "readers" {
  project_id = azuredevops_project.proj.id
  name       = "Readers"
}

resource "azuredevops_group_membership" "readers_members" {
  group = data.azuredevops_group.readers.descriptor
  members = [
    azuredevops_group.code_read.descriptor,
    azuredevops_group.stakeholders.descriptor
  ]
}

resource "azuredevops_group_membership" "code_read_members" {
  group = azuredevops_group.code_read.descriptor
  members = [
    azuredevops_group.process_administrator.descriptor
  ]
}

data "azuredevops_group" "contributors" {
  project_id = azuredevops_project.proj.id
  name       = "Contributors"
}

resource "azuredevops_group_membership" "contributors_members" {
  group = data.azuredevops_group.contributors.descriptor
  members = [
    azuredevops_group.code_write.descriptor
  ]
}

resource "azuredevops_group_membership" "code_write_members" {
  group = azuredevops_group.code_write.descriptor
  members = [
    azuredevops_group.devops.descriptor
  ]
}
