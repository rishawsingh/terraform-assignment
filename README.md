# terraform-assignment

## Assignment:
### Terraform Script to Deploy a WordPress Application

Introduction:
As a DevOps Intern, you have been tasked with writing a Terraform script that can deploy a WordPress application.
The script should be written in a clean and maintainable way and should handle all corner cases. Additionally, the script should be able to roll back and delete all resources if anything fails during deployment.
The chosen cloud provider for this assignment is AWS, but you are free to choose any of the other cloud providers - GCP or Azure.

### Requirements:

- Create an EC2 instance t4g.small and one RDS instance t4g.micro.
- The RDS instance should not be publicly accessible and should only be exposed to the EC2 instance.
- The script should also perform deployment and take the latest image of WordPress from Docker.
- The WordPress application should be exposed on port 80.
- Create an Elastic IP and attach it to the EC2 instance.
- If the bonus points are to be achieved, deploy Let's Encrypt and attach a domain to it so that the application can be accessed through the domain name.
- The Terraform script should be uploaded to a public GitHub repository.
- The repository's README file should be updated with all the necessary instructions to run the script, including the requirements, deployment steps, and any other relevant details.

### Bonus Points:
- Deploy Let's Encrypt and attach a domain to the application so that the IP address can be replaced by a domain name.
- Add phpmyadmin in deployment on same instance, so that one can access Database.

### Deliverables:

- Terraform script that can deploy a WordPress application with the above requirements.
- The script should handle all corner cases and be able to roll back and delete all resources if anything fails during deployment.
- The Terraform script should be uploaded to a public GitHub repository.
- The repository's README file should be updated with all the necessary instructions to run the script, including the requirements, deployment steps, and any other relevant details.


## Solution (Approach Used)
- Used AWS as provider, considering the user has already cofngiured login using AWS ACCESS KEY and ACCESS SECRET KEY.
- The solution is partitioned into five files-
 1. providers.tf
 2. variables.tf
 3. terraform.tfvars
 4. main_assessment.tf
 5. bonus.tf
 
- Added all the requirements of first part in the main_assessment file. Added phpmyadmin in the EC2 instace in the same file.
- Let's Encypt is added in the bonus.tf file.


## To run the Terraform script that you've created, you'll need to follow these steps:

- Install Terraform on your machine by following the instructions for your operating system at https://www.terraform.io/downloads.html.

- Open a terminal or command prompt in the directory where you saved the Terraform script.

- Initialize the Terraform working directory by running the following command:
```
terraform init
```
This command downloads the necessary providers and modules that are specified in the Terraform script.

- Validate the Terraform script by running the following command:

```
terraform validate
```
This command checks the syntax and configuration of the Terraform script.

- Preview the changes that Terraform will make by running the following command:

```
terraform plan
```
This command shows the resources that Terraform will create or modify. Make sure that the output matches your expectations.

- Apply the changes by running the following command:

```
terraform apply
```
This command creates or modifies the resources that are defined in the Terraform script. Terraform will ask for confirmation before applying the changes.

After the script has finished running, it will output the public IP address of the EC2 instance. You can use this IP address to access the WordPress application.

To access phpMyAdmin, you can use the public IP address of the EC2 instance followed by ``` /phpmyadmin ``` in the browser.

To access the WordPress application using a domain name, you'll need to follow the instructions provided by Let's Encrypt to obtain a certificate and configure the domain name to point to the Elastic IP address that was created by the Terraform script.



