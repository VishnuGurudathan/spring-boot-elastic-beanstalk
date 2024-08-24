# Spring Boot Elastic Beanstalk Deployment

This repository contains a sample Spring Boot multi-module Maven project along with Terraform code to provision and deploy the application to AWS Elastic Beanstalk.
## Overview

This project demonstrates how to deploy a multi-module Maven Spring Boot application to AWS Elastic Beanstalk using Terraform for infrastructure provisioning. Elastic Beanstalk provides a managed platform for deploying and scaling web applications, enabling developers to focus on building their applications without worrying about the underlying infrastructure.

## Prerequisites

Before you begin, ensure you have the following:

- An AWS account with permissions to create and manage Elastic Beanstalk environments.
- Terraform installed on your local machine.
- Familiarity with AWS Elastic Beanstalk, Maven, Spring Boot, and basic command-line tools.

## Project Structure

The repository is structured as follows:

```bash

spring-boot-elastic-beanstalk/
│
├── terraform/                    # Terraform configuration files for Elastic Beanstalk
│   ├── envs/dev/                 # Environment-specific Terraform state configuration
│   │   └── tfstate.conf          # Configuration for managing Terraform state
│   ├── modules/aws/              # Terraform modules for AWS resources
│   ├── main.tf                   # Main Terraform configuration file
│   └── variables.tf              # Terraform variables file
│
├── spring-boot-multimodule/      # Multi-module Maven Spring Boot project
│   ├── domain/                   # Domain module with its own pom.xml
│   ├── web-app/                  # Web application module with its own pom.xml
│   ├── assembly.xml              # Maven Assembly plugin configuration for packaging
│   ├── Procfile                  # Procfile to specify the command to run the Spring Boot application
│   └── pom.xml                   # Parent pom.xml for multi-module project
│
└── README.md                     # Project documentation

```

### Key Files and Directories

- __terraform/envs/dev/tfstate.conf__: Contains environment-specific Terraform state configuration. This file is essential for managing the state of your Terraform resources, particularly when working with multiple environments like development, staging, and production.

- __assembly.xml__: This file is used by the Maven Assembly plugin to create a zip package of the Spring Boot application. It includes the necessary .jar files and the Procfile needed for deployment to Elastic Beanstalk.

- __Procfile__: The Procfile is a crucial file in the Elastic Beanstalk deployment process. It specifies the command to run your Spring Boot application on the Elastic Beanstalk environment. If your application bundle contains more than one JAR file, the Procfile tells Elastic Beanstalk which JAR(s) to run. Even for a single JAR application, including a Procfile is recommended to precisely control the processes that Elastic Beanstalk should run.

    Example content of Procfile:

    ```plaintext

    web: java -Xms256m -jar server.jar
    cache: java -jar mycache.jar
    web_foo: java -jar other.jar```
    
- The command that runs the main JAR in your application must be named web, and it must be the first command listed in your Procfile. For this application, the Procfile should contain ```web: java -jar web-app.jar``` as the first and only command since no other services will run alongside.
- Elastic Beanstalk forwards all HTTP requests from your environment's load balancer to this application.
- Elastic Beanstalk assumes that all entries in the Procfile should run at all times and automatically restarts any application defined in the Procfile that terminates.

***Note***: Since this is a multimodule project you need to mention thae Jar details in Procfile then only Elastic Beanstalk can run it properlly 
For more details about writing and using a Procfile, see the AWS documentation on [Extending Elastic Beanstalk Linux platforms](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-linux-extend.html).

### Steps for Setup & Deployment

1. **Clone the Repository**: Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/yourusername/spring-boot-elastic-beanstalk.git
cd spring-boot-elastic-beanstalk
```

2. **Configure Your Spring Boot Project**: Ensure your multi-module Maven Spring Boot project is correctly configured, with each module having its own pom.xml file.

3. **Build and Package Your Application**: Use Maven to build your application and package the necessary .jar files into a zip archive using the Maven Assembly plugin.

4. **Create Infrastructure with Terraform**: Navigate to the terraform/ directory and use Terraform to provision the necessary AWS resources, including the Elastic Beanstalk environment.

```bash

terraform init
terraform apply
```

Check the readme file in terraform/ directory

5. **Deploy Your Application to Elastic Beanstalk**: Upload the zip file containing your application files and the Procfile to Elastic Beanstalk, and deploy it using the AWS Management Console or CLI.

```bash

    eb init
    eb create
    eb deploy
```

## Conclusion

By following the steps outlined in this repository, you can efficiently deploy a multi-module Maven Spring Boot project to AWS Elastic Beanstalk. The combination of Terraform and the Maven Assembly plugin provides a streamlined and automated process for managing both your application's infrastructure and deployment.
