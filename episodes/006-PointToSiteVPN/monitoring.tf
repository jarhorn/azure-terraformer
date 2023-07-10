data "terraform_remote_state" "monitor" {
  backend = "local"
  config = {
    path = var.monitoring_state_path
  }
}

locals {
  monitor_remote_outputs          = data.terraform_remote_state.monitor.outputs
  monitor_resource_group          = local.monitor_remote_outputs.monitor_resource_group
  monitor_storage_account         = local.monitor_remote_outputs.monitor_storage_account
  monitor_log_analytics_workspace = local.monitor_remote_outputs.monitor_log_analytics_workspace
  base64_script                   = filebase64("LinuxDiagnostic/install_python.sh")
}

resource "azurerm_virtual_machine_extension" "python_install" {
  name                       = "CustomScript"
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.0"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    { 
      "script": "${local.base64_script}"
    }
  SETTINGS
}

resource "time_offset" "sas_expiry" {
  offset_years = 10
}

resource "time_offset" "sas_start" {
  offset_days = -10
}

data "azurerm_storage_account_sas" "sas" {
  connection_string = local.monitor_storage_account.primary_connection_string
  https_only        = true
  expiry            = time_offset.sas_expiry.rfc3339
  start             = time_offset.sas_start.rfc3339

  resource_types {
    container = true
    object    = true
    service   = true
  }

  services {
    blob  = true
    file  = false
    queue = false
    table = true
  }

  permissions {
    add     = true
    create  = true
    delete  = true
    filter  = true
    list    = true
    process = true
    read    = true
    tag     = true
    update  = true
    write   = true
  }
}

resource "azurerm_virtual_machine_extension" "linux_diagnostic" {
  name                       = "LinuxDiagnostic"
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "LinuxDiagnostic"
  type_handler_version       = "3.0"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "StorageAccount": "${local.monitor_remote_outputs.monitor_storage_account.name}",
      "ladCfg": {
          "diagnosticMonitorConfiguration": {
                "eventVolume": "Medium", 
                "metrics": {
                     "metricAggregation": [
                        {
                            "scheduledTransferPeriod": "PT1H"
                        }, 
                        {
                            "scheduledTransferPeriod": "PT1M"
                        }
                    ], 
                    "resourceId": "${azurerm_linux_virtual_machine.vm.id}"
                },
                "performanceCounters": ${file("${path.module}/LinuxDiagnostic/perf_counters.json")},
                "syslogEvents": ${file("${path.module}/LinuxDiagnostic/syslog_events.json")}
          }, 
          "sampleRateInSeconds": 15
      }
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${local.monitor_remote_outputs.monitor_storage_account.name}",
        "storageAccountSasToken": "${data.azurerm_storage_account_sas.sas.sas}",
        "storageAccountEndPoint": "https://core.windows.net",
         "sinksConfig":  {
              "sink": [
                {
                    "name": "SyslogJsonBlob",
                    "type": "JsonBlob"
                },
                {
                    "name": "LinuxCpuJsonBlob",
                    "type": "JsonBlob"
                }
              ]
        }
    }
    SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.python_install
  ]
}
