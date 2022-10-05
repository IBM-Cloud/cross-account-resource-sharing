# read account settings for account "project 1" using
# the related provider alias
data "ibm_iam_account_settings" "project1_iam_account_settings" {
  provider = ibm.project1_account
}

# read account settings for the account identified
# by the default provider configuration
data "ibm_iam_account_settings" "default_iam_account_settings" {
}
