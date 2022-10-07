# See https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy
# IBM Cloud IAM service to service authorization policy
#
# An Cloud Object Storage located in the source service account is granted Reader permission on
# the Key Protect instance with a named keyring in the target account.
# Note that resource_attributes is used to describe all properties of the targeted service.
#
# The code is executed on the target account where the permission is granted.
resource "ibm_iam_authorization_policy" "cos_to_kms_policy" {
  provider = ibm.target_account


  source_service_account      = data.ibm_iam_account_settings.source_iam_account_settings.account_id
  source_resource_instance_id = data.ibm_resource_instance.source_cos_resource_instance.guid
  source_service_name         = "cloud-object-storage"

  resource_attributes {
    name     = "accountId"
    operator = "stringEquals"
    value    = data.ibm_iam_account_settings.target_iam_account_settings.account_id
  }

  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "kms"
  }
  resource_attributes {
    name     = "serviceInstance"
    operator = "stringEquals"
    value    = ibm_resource_instance.target_kms_instance.guid
  }
  resource_attributes {
    name     = "keyRing"
    operator = "stringEquals"
    value    = ibm_kms_key_rings.some_key_ring.key_ring_id
  }


  roles       = ["Reader"]
  description = "reverse policy in other account"
}
