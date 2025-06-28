# learn-terraform-aft-account-customizations

This repository is part of AWS Control Tower Account Factory for Terraform (AFT). It is used to apply **custom Terraform configurations to specific accounts** after the account is provisioned and global customizations are completed.

## 📌 Purpose

The `account-customizations` repository lets you define **account-specific infrastructure** or configuration that should be deployed **only to a targeted account**. It's ideal for deploying resources or permissions that are unique to a specific environment (e.g., dev, prod, audit).

## ⚙️ When It Runs

- 🔄 Runs **after** account provisioning
- 🕒 Runs **after** global customizations
- 🎯 Applies only to accounts that explicitly reference it in their `account-request` configuration

## ✅ Common Use Cases

- Creating custom **IAM roles**, **SSM documents**, or **policies** specific to one account
- Provisioning account-specific **VPC**, **S3 buckets**, or **CloudWatch alarms**
- Setting up unique **network or security rules**
- Deploying CI/CD pipelines or integrations needed only in that account
- Customizing logging, encryption, or guardrails for dev/prod/test accounts individually

## 📂 Folder Structure

```bash
customizations/
├── dev-account/
│   └── main.tf
├── prod-account/
│   └── main.tf
└── audit-account/
    └── main.tf
```

The folder name (e.g., `dev-account`) must match the `account_customizations_name` specified in the corresponding account-request module.

## 🧾 Example in account-request

```hcl
module "dev_account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountName               = "dev"
    AccountEmail              = "dev@example.com"
    ManagedOrganizationalUnit = "Workload-OU"
    SSOUserEmail              = "devuser@example.com"
    SSOUserFirstName          = "Dev"
    SSOUserLastName           = "User"
  }

  account_customizations_name = "dev-account"  # Must match folder name
}
```

## 🛠 Sample Customization (customizations/dev-account/main.tf)

```hcl
resource "aws_iam_role" "developer_role" {
  name = "DeveloperRole"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_s3_bucket" "dev_logs" {
  bucket = "dev-logs-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}
```

## 🧠 Best Practices

- Keep customizations modular and reusable per account
- Avoid duplicating logic that belongs in global customizations
- Ensure naming conventions match between account-request and customizations/ folders

## 📎 Related Repositories

- `learn-terraform-aft-account-requests`
- `learn-terraform-aft-account-provisioning-customizations`
- `learn-terraform-aft-global-customizations`

---

