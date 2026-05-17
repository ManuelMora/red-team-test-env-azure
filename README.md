# Azure Red Team Test Environment

This repository is designed to deploy a private penetration testing environment in Azure, featuring:

- **Kali Linux attacker host** for offensive tooling, reconnaissance, and exploitation
- **Target host** for vulnerability testing and security validation
- **Isolated network architecture** to limit exposure and keep the lab contained
- **Terraform-based deployment** for repeatable and auditable provisioning

## Objective

Create a secure, isolated Azure lab for red team / penetration testing exercises. The environment should provide:

- Kali Linux as the attacker machine
- One or more target machines configured for realistic testing
- Network segmentation and optional bastion or jump host access
- Clear deployment and cleanup guidance

## Recommended Architecture

1. **Virtual Network (VNet)**
   - Private subnet for the target host
   - Optional public subnet for the Kali host or bastion
2. **Kali Linux VM**
   - Hardened but accessible from a controlled administrative network
   - SSH and optional remote desktop access
3. **Target VM**
   - Configured with intentional vulnerabilities or misconfigurations for testing
   - Can run Windows, Linux, or both depending on lab needs
4. **Security Controls**
   - Network Security Groups (NSGs) to restrict traffic
   - Azure Bastion or jump box access for admin
   - Optional monitoring/logging for detection testing

## Deployment with Terraform

This project uses Terraform exclusively to provision Azure resources.

For a step-by-step deployment tutorial, see `START.md`.

### Terraform files

Typical files for this repo may include:

- `main.tf` — core Azure provider, virtual network, NSGs, and VM resources
- `variables.tf` — input variables for subscription, region, VM sizes, and network settings
- `outputs.tf` — useful output values like Kali VM public IP and target host private IP
- `terraform.tfvars` — local variable values for deployment settings

## Usage

1. Connect to the Kali Linux VM.
2. Validate access to the target host over the lab network.
3. Run penetration testing tools and scenarios such as:
   - `nmap`, `masscan`
   - `metasploit`
   - `burpsuite`
   - `hydra`, `john`, `hashcat`
4. Document findings and clean up the environment when finished.

## Clean Up

Destroy all Terraform-managed resources to avoid unexpected costs:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Best Practices

- Keep the lab isolated from production networks
- Use a dedicated Azure subscription or resource group
- Restrict administrative access with MFA and just-in-time controls
- Label resources clearly for testing and cost tracking
- Review Azure activity logs to monitor lab actions

## Notes

- This repo is intended as a Terraform deployment scaffold for a private Azure pentest lab.
- Customize the VM sizes, OS images, and security settings to match your testing objectives.
- Always obtain permission before conducting penetration tests.
