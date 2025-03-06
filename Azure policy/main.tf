data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "tag" {
    name = "allowed-tag"
    policy_type = "Custom"
    mode = "All"
    display_name = "Allowed tag ploicy"

    policy_rule = jsonencode({
        if = {
            anyOf = [
                {
                    field = "tags[${var.allowed_tags[0]}]",
                    exists = false
                },
                {
                    field = "tags[${var.allowed_tags[1]}]",
                    exists = false
                }
            ]
        }
        then = {
            effect = "deny"
        }
    })
  
}

resource "azurerm_subscription_policy_assignment" "tag-ploicy-assingment" {
    name = "custom-tag-policy"
    policy_definition_id = azurerm_policy_definition.tag.id
    subscription_id = data.azurerm_subscription.current.id
  
}


resource "azurerm_policy_definition" "vm-size" {
    name = "allowed-vm-size"
    policy_type = "Custom"
    mode = "All"
    display_name = "Allowed vm size ploicy"

    policy_rule = jsonencode({
        if = {
                field = "Microsoft.Compute/virtualMachines/sku.name",
                notIn = ["${var.vm_sizes[0]}", "${var.vm_sizes[1]}"]
             }
        then = {
            effect = "deny"
        }
    })
  
}

resource "azurerm_subscription_policy_assignment" "vm-size-ploicy-assingment" {
    name = "custom-vm-size-policy"
    policy_definition_id = azurerm_policy_definition.vm-size.id
    subscription_id = data.azurerm_subscription.current.id
  
}

resource "azurerm_policy_definition" "location" {
    name = "allowed-location"
    policy_type = "Custom"
    mode = "All"
    display_name = "Allowed location ploicy"

    policy_rule = jsonencode({
        if = {
                field = "location",
                notIn = ["${var.location[0]}", "${var.location[1]}"]
             }
        then = {
            effect = "deny"
        }
    })
  
}

resource "azurerm_subscription_policy_assignment" "location-ploicy-assingment" {
    name = "custom-location-policy"
    policy_definition_id = azurerm_policy_definition.location.id
    subscription_id = data.azurerm_subscription.current.id
  
}

resource "azurerm_subscription_policy_remediation" "location-remediation" {
  name                 = "location-policy-remediation"
  subscription_id      = data.azurerm_subscription.current.id
  policy_assignment_id = azurerm_subscription_policy_assignment.location-ploicy-assingment.id
}

resource "azurerm_subscription_policy_remediation" "tag-remediation" {
  name                 = "tag-policy-remediation"
  subscription_id      = data.azurerm_subscription.current.id
  policy_assignment_id = azurerm_subscription_policy_assignment.tag-ploicy-assingment.id
}

resource "azurerm_subscription_policy_remediation" "vm-size-remediation" {
  name                 = "vm-size-policy-remediation"
  subscription_id      = data.azurerm_subscription.current.id
  policy_assignment_id = azurerm_subscription_policy_assignment.vm-size-ploicy-assingment.id
}