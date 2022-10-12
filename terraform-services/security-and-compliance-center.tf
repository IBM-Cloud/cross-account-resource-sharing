# Set up new credentials within the corporate Security and Compliance Center instance,
# then define a scope and kick off an initial scan.

# retrieve all profiles, including "IBM Cloud Security Best Practices" and "IBM Cloud for Financial Services"
data "ibm_scc_posture_profiles" "list_profiles" {
  provider = ibm.corporate_account
}

# retrieve already defined collectors
# see https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/scc_posture_collectors
data "ibm_scc_posture_collectors" "list_collectors" {
  provider = ibm.corporate_account
}

# define credentials for the IBM Cloud project account
# see https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/scc_posture_credential
resource "ibm_scc_posture_credential" "ibmcloud_target_credentials" {
    provider = ibm.corporate_account
    description = "credentials for project 42 account"
    name = "project42_credentials"
    display_fields {
      ibm_api_key= var.ibmcloud_api_key_project42
    }
    # the "group" has been deprecated and is not used
    group {
     id = "123"
     passphrase = "notneeded"
    }
    enabled = true
    type = "ibm_cloud"
    purpose = "discovery_collection"
  
}

# define a new scope for the specified scope
# see https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/scc_posture_scope
resource "ibm_scc_posture_scope" "project42_scope" {
  provider        = ibm.corporate_account
  credential_id   = ibm_scc_posture_credential.ibmcloud_target_credentials.id
  credential_type = "ibm"
  collector_ids   = [data.ibm_scc_posture_collectors.list_collectors.collectors[index(data.ibm_scc_posture_collectors.list_collectors.collectors.*.name, "mycoll_ibm")].id]
  description     = "scan project account"
  name            = "scope4project42"
}

# define and kick off the validation scan
# see https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/scc_posture_scan_initiate_validation
resource "ibm_scc_posture_scan_initiate_validation" "project42_validation" {
  provider          = ibm.corporate_account
  scope_id          = ibm_scc_posture_scope.project42_scope.id
  profile_id        = data.ibm_scc_posture_profiles.list_profiles.profiles[index(data.ibm_scc_posture_profiles.list_profiles.profiles.*.name, "IBM Cloud for Financial Services v0.6.0")].id
  name              = "ad-hoc scan"
  description       = "scan project 42"
  no_of_occurrences = 1
}


