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

## Rollback Procedure

In the event that a deployment does not go as planned, or if an update causes issues in the production environment, it's crucial to have a rollback strategy to revert to the previous stable version of the application.

### Automated Rollback with GitHub Actions

The repository includes a GitHub Actions workflow that is dedicated to handling rollbacks. This workflow can be manually triggered via the GitHub UI and requires specifying the version to which you want to rollback.

To initiate a rollback:

1. Navigate to the `Actions` tab in the GitHub repository.
2. Select the `Automated Rollback` workflow.
3. Click on `Run workflow`.
4. Enter the tag of the Docker image you want to rollback to. This is typically the commit SHA of the previous stable release.
5. Click on `Run workflow` to start the rollback process.

The rollback workflow will update the Kubernetes deployment to use the specified Docker image tag, effectively rolling back the application to that version.

### Manual Rollback Using kubectl

If you need to manually rollback to a previous deployment:

1. Ensure you have `kubectl` configured with access to your Kubernetes cluster.
2. Use the `rollout undo` command to revert the deployment to the previous version:

```sh
kubectl rollout undo deployment/<deployment-name>
```

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
docker run -p 80:5000 my-application
```

Then, open a web browser and navigate to `http://localhost` to see the "Hello, World!" message.

## Deploying to AWS EKS

To deploy the application to an AWS EKS cluster, you need to have your AWS credentials configured and Terraform installed on your system.

### Deploy the Infrastructure

Initiate and Apply the Terraform configuration to provision the EKS cluster:

```sh
terraform init
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


# Monitoring Setup Guide

This repository contains a setup script (`setup-monitoring.sh`) for deploying Prometheus and Grafana on a Kubernetes cluster. Follow the steps below to set up monitoring for your cluster.

## Setup Instructions

1. **Run the setup script**: Execute the setup script to deploy Prometheus and Grafana on your Kubernetes cluster.
   
   ```bash
   ./setup-monitoring.sh
   ```

2. **Accessing Grafana**:
   - **URL**: To access Grafana, use the following URL:
     ```
     http://localhost:3000
     ```
   - **Username**: Use `admin` as the username.
   - **Password**:  Use `EKS!sAWSome` as the password.
   The password is dynamically generated during the installation. You can retrieve it by running the following command:
   
     ```bash
     kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
     ```

   Once you have the password, log in using the provided credentials.

3. **Accessing Prometheus**:
   - **URL**: Prometheus can be accessed using the following URL:
     ```
     http://prometheus-server.monitoring.svc.cluster.local
     ```
   - **Port Forwarding**: To access Prometheus locally, you can use port forwarding:
   
     ```bash
     export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace monitoring port-forward $POD_NAME 9090
     ```

4. **Additional Notes**:
   - Ensure that you have the necessary permissions to deploy resources on the cluster.
   - For more information on running Prometheus and Grafana, visit their official websites ([Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/)).

```
