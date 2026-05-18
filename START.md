# Start Here: Deploy the Azure Red Team Lab

This tutorial covers deploying the Azure red team test environment with Terraform.

## Prerequisites

- Terraform installed locally (>= 1.5)
- Azure CLI installed
- A valid Azure subscription
- An SSH public key available locally

## 1. Authenticate to Azure

Open PowerShell in the project folder and run:

```powershell
az login
az account set --subscription "<subscription-id>"
```

## 2. Prepare Terraform variables

Copy the example variables file and edit deployment settings:

```powershell
Copy-Item .\terraform.example.tfvars .\terraform.tfvars
```

Update `terraform.tfvars` for your environment:

- `allowed_admin_cidr` should be your trusted IP CIDR
- `ssh_public_key_path` should point to your SSH public key file (e.g. `C:\Users\you\.ssh\id_rsa.pub`)
- optionally adjust VM names, sizes, region, or target image values

## 3. Initialize Terraform

Run:

```powershell
terraform init
```

This downloads the Azure provider and initializes the working directory.

## 4. Review the deployment plan

Run:

```powershell
terraform plan -var-file="terraform.tfvars"
```

Verify the planned resources include:

- Resource group
- Virtual network and subnets
- Network security groups
- Public IP for the Kali VM
- Kali Linux VM
- Target VM

## 5. Apply the deployment

Run:

```powershell
terraform apply -var-file="terraform.tfvars"
```

Confirm the apply step when prompted. After completion, Terraform outputs will include:

- `kali_public_ip`
- `target_private_ip`
- the SSH connection command

## 6. Connect to the Kali VM

Use the public IP output to connect:

```powershell
ssh azureuser@<kali_public_ip>
```

## 7. Validate the lab

From the Kali VM, verify connectivity to the target host and test with tools such as:

- `nmap`
- `ping`
- `metasploit`
- `burpsuite`

Use the target VM private IP from the outputs.

## 8. Cleanup

Destroy the Terraform-managed resources when finished:

```powershell
terraform destroy -var-file="terraform.tfvars"
```

## Notes

- This repo uses Terraform only; there is no ARM/Bicep or manual Azure CLI provisioning required.
- If the Kali image values do not match marketplace availability, update `terraform.tfvars` to a supported image.
- Keep `allowed_admin_cidr` narrow for best security.
