locals {
  dynamic_group_name = "devops_dynamic_group_${random_string.deploy_id.result}"
}

resource "oci_identity_dynamic_group" "devops_dynamic_group" {
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  description    = "DevOps Dynamic Group for ${random_string.deploy_id.result}"
  matching_rule  = "ANY { ALL { resource.type = 'instance-family', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsbuildpipeline', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsrepository', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsconnection', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsrepository', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsdeployment', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopstrigger', resource.compartment.id = '${var.compartment_ocid}' }}"
  name           = local.dynamic_group_name
}


resource "oci_identity_policy" "devops_policy_in_tenancy" {
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  name           = "devops_policies_tenancy_${random_string.deploy_id.result}"
  description    = "Allow dynamic group to manage devops at tenancy level for ${random_string.deploy_id.result}"
  statements = [
    "allow dynamic-group ${local.dynamic_group_name} to manage devops-family in tenancy",
    "allow dynamic-group ${local.dynamic_group_name} to manage repos in tenancy",
  ]
}

resource "oci_identity_policy" "devops_policy_in_compartment" {
  provider       = oci.home_region
  compartment_id = var.compartment_ocid
  name           = "devops_policies_${random_string.deploy_id.result}"
  description    = "Allow dynamic group to manage devops for ${random_string.deploy_id.result}"
  statements = [
    "allow dynamic-group ${local.dynamic_group_name} to use virtual-network-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use instance-agent-command-execution-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage devops-repository in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage devops-connection in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage cluster in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage generic-artifacts in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage all-artifacts in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage compute-container-instances in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage compute-containers in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage adm-vulnerability-audits in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to read secret-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use dhcp-options in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use ons-topics in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use subnets in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use vnics in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use network-security-groups in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use adm-knowledge-bases in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use cabundles in compartment id ${var.compartment_ocid}"
  ]
}

resource "oci_identity_auth_token" "user_auth_token" {
  provider    = oci.home_region
  user_id     = data.oci_identity_users.users.users[0].id
  description = "user_auth_token_for_devops_${random_string.deploy_id.result}"
}
