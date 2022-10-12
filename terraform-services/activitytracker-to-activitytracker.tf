# retrieve resource data for corporate Activity Tracker instance
data "ibm_resource_instance" "targetaccount_atracker_resource_instance" {
  provider          = ibm.corporate_account
  name              = "IBM_Cloud_Activity_Tracker_target"
  resource_group_id = data.ibm_resource_group.target_resource_group.id
}


# set up the corporate Activity Tracker instance as target for routing
# see https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/atracker_target
resource "ibm_atracker_target" "atracker_logdna_target" {
  provider    = ibm.project_account
  target_type = "logdna"
  logdna_endpoint {
    target_crn    = data.ibm_resource_instance.targetaccount_atracker_resource_instance.id
    ingestion_key = var.targetaccount_atracker_ingestion_key
  }
  name   = "corporate-logdna-target"
  region = "eu-de"
}

# create the route to the target defined above, thereby enabling the event record routing
# see https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/atracker_route
resource "ibm_atracker_route" "atracker_route" {
  provider = ibm.project_account
  name     = "localaccount2globalaccount-route"
  rules {
    target_ids = [ibm_atracker_target.atracker_logdna_target.id]
    locations  = ["global", "eu-de", "us-south"]
  }
}
