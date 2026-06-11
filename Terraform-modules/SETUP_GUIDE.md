# Terraform AWS Webserver - Modular Setup Guide

## ✅ Errors Fixed

All Terraform configuration errors have been resolved. Here's what was fixed:

### 1. **Deprecated S3 Bucket Configuration** (backend-bootstrap/main.tf)
- ❌ **Old**: Used deprecated `acl`, `versioning`, and `server_side_encryption_configuration` arguments
- ✅ **Fixed**: Separated into individual resources:
  - `aws_s3_bucket` (core bucket)
  - `aws_s3_bucket_versioning` (versioning configuration)
  - `aws_s3_bucket_server_side_encryption_configuration` (encryption)
  - `aws_s3_bucket_public_access_block` (security)

### 2. **Storage Module S3 Configuration** (modules/storage/main.tf)
- ❌ **Old**: Same deprecated S3 bucket configuration
- ✅ **Fixed**: Refactored to use separate resources (same as backend-bootstrap)

## 📋 Project Structure

```
Terraform-modules/
├── backend-bootstrap/           # Bootstrap - creates S3 state bucket
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── modules/                     # Reusable modules
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── backend.tf                   # Remote state backend config
├── provider.tf                  # AWS provider configuration
├── variables.tf                 # Root variables
├── main.tf                      # Root module composition
├── outputs.tf                   # Root outputs
├── terraform.tfvars.example     # Example variables file
└── README.md                    # Documentation
```

> Note: To cretae the hierarchy and place all file with contents, run the setup.sh 

---

## 🚀 Quick Start

### Step 1: Create Bootstrap Resources (S3 + DynamoDB)

```bash
cd backend-bootstrap

# Initialize Terraform
terraform init

# Create S3 bucket and DynamoDB table for state management
terraform apply -auto-approve \
  -var="bucket_name=tfstate-webserver-$(date +%s)" \
  -var="region=us-east-1" \
  -var="environment=dev"

# Note the output bucket_name and lock_table for Step 2
terraform output
```

**Output will show:**
- `bucket_name`: Your S3 bucket for remote state
- `lock_table`: DynamoDB table for state locking

### Step 2: Configure Remote Backend (Root Directory)

```bash
cd ..

# Replace with your actual bucket name and table from Step 1
terraform init \
  -backend-config="bucket=tfstate-webserver-1718091234" \
  -backend-config="key=terraform-aws-webserver/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=tf-state-lock" \
  -backend-config="encrypt=true"
```

### Step 3: Create terraform.tfvars File

```bash
# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
vim terraform.tfvars
```

**Required variable: `ami_id`**
Get a valid AMI for your region:
```bash
# Example for us-east-1 (Amazon Linux 2)
ami_id = "ami-0c55b159cbfafe1f0"

# Or find your own:
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*" --query 'Images[0].ImageId' --region us-east-1
```

### Step 4: Plan and Apply

```bash
# Format all files
terraform fmt -recursive

# Validate configuration
terraform validate

# View what will be created
terraform plan

# Apply the configuration
terraform apply
```

### Step 5: Verify Resources

```bash
# Get outputs
terraform output

# Check resources in AWS
aws ec2 describe-instances --region us-east-1 --filters "Name=tag:Project,Values=Terraform-aws-Webserver"
aws s3 ls
```

## 🧹 Cleanup

To destroy all resources:

```bash
# From root directory
terraform destroy -auto-approve

# Then destroy bootstrap resources
cd backend-bootstrap
terraform destroy -auto-approve

# Manually delete S3 bucket (Terraform won't do this)
aws s3 rb s3://tfstate-webserver-1718091234 --force
```

## 📊 Module Details

### Network Module
- **Inputs**: region, environment, vpc_cidr, public_subnets
- **Outputs**: vpc_id, public_subnet_ids
- **Creates**: VPC, Public Subnets

### Security Module
- **Inputs**: vpc_id, environment
- **Outputs**: web_sg_id
- **Creates**: Security Group (allows HTTP 80, SSH 22)

### Compute Module
- **Inputs**: region, environment, ami_id, instance_type, instance_count, subnet_id, security_group_ids
- **Outputs**: instance_ids, instance_public_ips
- **Creates**: EC2 Instances with configurable count

### Storage Module
- **Inputs**: region, environment, bucket_prefix
- **Outputs**: bucket_name, bucket_arn
- **Creates**: S3 Bucket with versioning and encryption

## 🔒 Security Best Practices Implemented

✅ S3 buckets have:
- Server-side encryption (AES256)
- Versioning enabled
- Public access blocked
- State locking via DynamoDB

✅ EC2 instances have:
- Security group with restricted ingress rules
- Environment tags for tracking
- Root volume encryption enabled

✅ Remote state management:
- Centralized state in S3
- State file encryption
- Concurrent access protection (DynamoDB locks)

## 🐛 Troubleshooting

### Error: "Argument is deprecated"
**Solution**: Already fixed! All deprecated S3 arguments have been replaced with proper resource types.

### Error: "bucket already exists"
**Solution**: S3 bucket names must be globally unique. Use a different name or timestamp.

### Error: "ResourceNotFoundException" on terraform init
**Solution**: Ensure backend-bootstrap was applied first and you're using the correct bucket name.

### Error: "InvalidAMIID" when applying compute
**Solution**: Provide a valid AMI ID for your region using `-var="ami_id=ami-xxxxxxx"`

## 📚 Useful Commands

```bash
# Validate syntax without state
terraform validate

# Format code
terraform fmt -recursive

# Show resource graph
terraform graph | dot -Tsvg > graph.svg

# Show current state
terraform show

# Show specific output
terraform output instance_public_ips

# Refresh state without changing resources
terraform refresh

# Import existing resources
terraform import aws_instance.web i-1234567890abcdef0
```

## 📝 Additional Notes

- All Terraform files are formatted and validated
- Backend configuration uses placeholder values in `backend.tf` - use `-backend-config` flags during init
- Module outputs are connected at the root level in `main.tf`
- Default tags are applied to all AWS resources
- State file should NOT be committed to Git (see `.gitignore`)

---

**Status**: ✅ All errors fixed and validated
**Last Updated**: 2026
