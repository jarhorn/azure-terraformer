resource "azuredevops_branch_policy_min_reviewers" "minimum_reviewers" {
  project_id = azuredevops_project.proj.id
  enabled    = true
  blocking   = true

  settings {
    reviewer_count                         = 1
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true

    scope {
      match_type = "DefaultBranch"
    }
  }

  depends_on = [
    azuredevops_git_repository_file.files
  ]
}

resource "azuredevops_branch_policy_work_item_linking" "work_item_link" {
  project_id = azuredevops_project.proj.id
  enabled    = true
  blocking   = false

  settings {
    scope {
      match_type = "DefaultBranch"
    }
  }

  depends_on = [
    azuredevops_git_repository_file.files
  ]
}

resource "azuredevops_branch_policy_comment_resolution" "comment_resolution" {
  project_id = azuredevops_project.proj.id
  enabled    = true
  blocking   = false

  settings {
    scope {
      match_type = "DefaultBranch"
    }
  }

  depends_on = [
    azuredevops_git_repository_file.files
  ]
}

resource "azuredevops_branch_policy_merge_types" "merge_types" {
  project_id = azuredevops_project.proj.id
  enabled    = true
  blocking   = true

  settings {
    allow_squash                  = true
    allow_basic_no_fast_forward   = false
    allow_rebase_and_fast_forward = false
    allow_rebase_with_merge       = false

    scope {
      match_type = "DefaultBranch"
    }
  }

  depends_on = [
    azuredevops_git_repository_file.files
  ]
}

resource "azuredevops_branch_policy_build_validation" "build_validation" {
  project_id = azuredevops_project.proj.id
  enabled    = true
  blocking   = true

  settings {
    build_definition_id         = azuredevops_build_definition.pull_request.id
    display_name                = "Requires Pull Request Build Success"
    manual_queue_only           = false
    queue_on_source_update_only = true
    valid_duration              = 720

    scope {
      match_type = "DefaultBranch"
    }
  }

  depends_on = [
    azuredevops_git_repository_file.files
  ]
}

resource "azuredevops_branch_policy_auto_reviewers" "reviewers" {
  project_id = azuredevops_project.proj.id
  enabled    = true
  blocking   = true

  settings {
    auto_reviewer_ids = [
      azuredevops_group.code_write.origin_id
    ]
    submitter_can_vote          = false
    minimum_number_of_reviewers = 1

    scope {
      match_type = "DefaultBranch"
    }
  }

  depends_on = [
    azuredevops_git_repository_file.files
  ]
}
