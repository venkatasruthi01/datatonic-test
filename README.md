# Hello World Flask Application with AWS EKS Deployment

This repository contains all the necessary code and configuration for setting up a "Hello World" Flask application, containerizing it using Docker, and deploying it to an AWS Elastic Kubernetes Service (EKS) cluster.

## Repository Structure

### CI/CD Pipeline (`ci-cd.yml`)

This GitHub Actions workflow is responsible for automating the Continuous Integration and Continuous Deployment (CI/CD) pipeline. On every push to the `main` branch or pull request against it, the workflow will build a Docker image of the Flask application and deploy it to an AWS EKS cluster.

- **Build**: Compiles the Docker image from the Dockerfile.
- **Deploy**: Configures AWS credentials, updates kubeconfig, and deploys the application using `kubectl`.

### CodeQL Analysis (`codeql-analysis.yml`)

This separate GitHub Actions workflow runs CodeQL analysis to perform automated security checks on the codebase. It's triggered on push to `main`, pull request against `main`, and on a schedule (every Tuesday at 2:31 AM).

- **Analyze**: Scans the codebase for security vulnerabilities and code quality issues.

### Kubernetes Configuration (`k8s/` directory)

Contains Kubernetes manifest files for the application deployment.

- `deployment.yaml`: Defines the Kubernetes Deployment for running the Flask application with three replicas, ensuring high availability.

### Flask Application (`app.py`)

A simple Python Flask application that returns "Hello, World!" on the index route.

### Dockerfile

Defines the Docker container for the Flask application, setting up the Python environment, and exposing the necessary port.

### EKS Cluster Terraform Configuration (`eks-cluster.tf`)

Terraform configuration file that provisions an AWS EKS cluster using the AWS provider.

- Makes use of variable definitions for customization.

## Testing the Application

To test the application, follow these steps:

1. Clone the repository to your local machine.
2. Navigate to the repository directory.

   ```sh
   cd path-to-your-repo
   ```
   
## To build and run the Docker container locally:

```sh
docker build -t my-application .
docker run -p 80:80 my-application
```

Then, open a web browser and navigate to `http://localhost` to see the "Hello, World!" message.

## Deploying to AWS EKS

To deploy the application to an AWS EKS cluster, you need to have your AWS credentials configured and Terraform installed on your system.

### Deploy the Infrastructure

Apply the Terraform configuration to provision the EKS cluster:

```sh
terraform apply
```

### Configure AWS CLI and kubeconfig

Update your `kubeconfig` file to include your EKS cluster configuration:

```sh
aws eks --region <your-region> update-kubeconfig --name <cluster-name>
```

Remember to replace `<your-region>` and `<cluster-name>` with the actual values.

### Apply Kubernetes Manifests

Deploy the application to the EKS cluster using the provided Kubernetes manifests:

```sh
kubectl apply -f k8s/
```

After deployment, you can access your application via the LoadBalancer URL or NodePort assigned to it by Kubernetes.

For more information on managing and interacting with your AWS EKS cluster, please refer to the [AWS EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).
