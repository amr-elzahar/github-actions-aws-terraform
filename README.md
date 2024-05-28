# AWS Resources with Terraform and GitHub Actions

This repository contains configurations for provisioning AWS resources using Terraform, automated by GitHub Actions. It includes three workflows:

1. `state-backend.yaml` - Sets up the S3 bucket and DynamoDB table for storing the Terraform state file.
2. `terraform-apply.yaml` - Provisions AWS resources defined in Terraform configuration.
3. `terraform-destroy.yaml` - Cleans up and destroys the AWS resources.

All workflows are configured to run manually.

## Setting Up OIDC for AWS Authentication

To authenticate against AWS using OpenID Connect (OIDC), follow these steps:

1. **Create an OIDC Identity Provider**:

   - Refer to [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services).

2. **Create a Role with Web Identity**:

   - Choose the identity provider created earlier.
   - Configure the audience, organization, repository, and branch.

3. **Assign Appropriate Permissions**:

   - Ensure the role has the necessary permissions for your tasks.

4. **Get the ARN of the Role**:
   - Use this ARN in your workflow files.

This method of authentication is more secure as it provides the workflow with temporary credentials, rather than using static credentials stored as secrets.
