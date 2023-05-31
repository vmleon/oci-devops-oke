locals {
  dynamic_group_name = "devops_dynamic_group_${random_string.deploy_id.result}"
}

resource "oci_identity_dynamic_group" "devops_dynamic_group" {
    compartment_id = var.tenancy_ocid
    description = "DevOps Dynamic Group for ${random_string.deploy_id.result}"
    matching_rule = <<EOT
        ANY {
            ALL {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}, 
            ALL {resource.type = 'devopsrepository', resource.compartment.id = '${var.compartment_ocid}'}, 
            ALL {resource.type = 'devopsbuildpipeline',resource.compartment.id = '${var.compartment_ocid}'}
            }
        EOT
    name = local.dynamic_group_name
}

resource "oci_identity_policy" "devops_policy" {
  compartment_id = var.tenancy_ocid
  name           = "devops_policies_${random_string.deploy_id.result}"
  description    = "Allow dynamic group to manage devops for ${random_string.deploy_id.result}"
  statements     = [
    "allow dynamic-group ${local.dynamic_group_name} to manage devops-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use devops-connection in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to read secret-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage repos in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage cluster in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage generic-artifacts in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to read all-artifacts in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage compute-container-instances in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage compute-containers in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use dhcp-options in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use ons-topics in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use subnets in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use vnics in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use network-security-groups in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use adm-knowledge-bases in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage adm-vulnerability-audits in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use cabundles in compartment id ${var.compartment_ocid}"
    ]
}