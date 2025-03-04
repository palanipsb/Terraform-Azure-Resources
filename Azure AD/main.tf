data "azuread_domains" "aad" {
    only_initial = true
  
}

locals {
  domain = data.azuread_domains.aad.domains.*.domain_name
  users       = csvdecode(file("/users.csv"))
}

resource "azuread_user" "users" {
    for_each = { for user in  local.users: user.first_name => user }
    user_principal_name = format("%s.%s@%s", lower(each.value.first_name),lower(each.value.last_name),"palanipsbgmail.onmicrosoft.com")
    password = format("%s%s%s!",lower(each.value.last_name),upper(substr(each.value.first_name,0,3)),length(each.value.first_name))
    display_name = "${each.value.first_name} ${each.value.last_name}"
    force_password_change = true
    department = each.value.department
    job_title = each.value.job_title
}

