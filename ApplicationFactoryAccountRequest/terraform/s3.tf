data "aws_caller_identity" "current" {
  # This data source retrieves the current AWS account ID
  # It is used to dynamically create unique resource names
  # based on the account ID.
  # No additional configuration is needed.
  # It automatically uses the credentials configured in the AWS provider.
  # Example usage: "aft-sandbox-${data.aws_caller_identity.current.account_id}"
  # This will create a bucket name like "aft-sandbox-123456789012"
}

resource "aws_s3_bucket" "prod_bucket" {
  bucket = "aft-prod-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}
