# Terraform Provisioner Automation for Resource Provisioning and Application Deployment.
- Terraform project focused on utilizing Terraform's provisioners to automate resource provisioning and application deployment on AWS EC2 instances.

## Structure 
- **main.tf**: Contains Terraform configurations for provisioning VPC, key pair, EC2 instance, and provisioners.
- **provider.tf**: Contains the prvider configuration.
- **variables.tf**: Defines input variables used in the terraform configuration.
- **app.py**: Simple python flask application to be deployed on to the EC2-Instance.

## Getting Started
- Clone this repository using git clone.
- Configure the app.py file according to your requirements.
- Initialize the terraform and use terraform commands to plan, apply to create the AWS Infrastructure and access the appication using the public IP-Address.
