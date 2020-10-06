# Terraform Setup

Terraform setup to spin up a complete Kubernetes runtime on Google Cloud.

## Structure

Description of files and directories within this directory.

| Path                             | Description |
|----------------------------------|-------------------------------------------|
| [`env/`](./env)                  | Environment specific cofigurations        |
| [`modules/`](./modules)          | Directory with [Terraform modules][terraform_module] |
| [`backend.tf`](./backend.tf)     | Configuration of [Terraform state backend][terraform_backend] |
| [`modules.tf`](./modules.tf)     | Configuration of Terraform modules in `/modules` |
| [`providers.tf`](./providers.tf) | Configuration of [Terraform providers][terraform_providers] |
| [`variables.tf`](./variables.tf) | Declaration of top level project variables |

[terraform_module]: https://www.terraform.io/docs/modules/index.html
[terraform_backend]: https://www.terraform.io/docs/backends/index.html
[terraform_providers]: https://www.terraform.io/docs/providers/google/index.html

## Prerequsite

* Google Cloud Platform (GCP) service account for Terraform
* Google Cloud Storage (GCS) bucket for Terraform state

## Setup

### Google Cloud CLI

Log in to Google Cloud using the `gcloud` command line:

```bash
gcloud auth login
```

Set the following configurations:

```bash
gcloud config set account <my_user_account>
gcloud config set project andersrunningen-test
gcloud config set compute/region europe-north1
```

### Create Service Account

Create a new Service Account for running Terraform:

```bash
gcloud iam service-accounts create terraform
```

Grant the new Service Account owner permissions:

```bash
gcloud projects add-iam-policy-binding andersrunningen-test \
  --member serviceAccount:terraform@andersrunningen-test.iam.gserviceaccount.com \
  --role roles/owner
```

Create a credential for the Service Account by running the following command:

```bash
gcloud iam service-accounts keys create \
  --iam-account terraform@andersrunningen-test.iam.gserviceaccount.com \
  andersrunningen-test.json
```

Move the `.json` file somewhere safe and set the following environment variables:

```bash
export GOOGLE_CREDENTIALS=$(cat ~/my/path.json | tr -d '\n')
export TERRAFORM_ENVIRONMENT=test
export TERRAFORM_STATE_GCP_BUCKET=andersrunningen-test-tf-state
```

Create an encryption key for encrypting the content of the Terraform State and
keep it somewhere safe:

```bash
openssl rand -base64 32 > ~/my/path.enc
export GOOGLE_ENCRYPTION_KEY=$(cat ~/my/path.enc)
```

### Create Backend Storage

Create a bucket for storing the Terraform state:

```bash
gsutil mb -b on -c regional -l europe-north1 gs://${TERRAFORM_STATE_GCP_BUCKET}
```

## Terraform Init

```bash
terraform init -reconfigure -backend-config="bucket=${TERRAFORM_STATE_GCP_BUCKET}"
terraform workspace new ${TERRAFORM_ENVIRONMENT}
```

## Terraform Plan

```bash
terraform plan -var-file=env/${TERRAFORM_ENVIRONMENT}.tfvars
```

## Terraform Apply

```bash
terraform apply -var-file=env/${TERRAFORM_ENVIRONMENT}.tfvars
```

## Kubernetes Credentials

Run the following command in order to fetch the credentials for the new
Kubernetes cluster:

```bash
gcloud container clusters get-credentials andersrunningen-test-gke --zone europe-west1-b
```

You can now list the running pods with the `kubectl` command:

```bash
kubectl get pods --all-namespaces
```

## After First Apply

There are a few things you have to do manually after the first apply:

* Set up the appropriate DNS Zone in the Root DNS server
* Open firewall rules on the shared VPC project (check logs after first Ingress,
  this must only be run once). Copy the command you see in the event logs:

```bash
kubectl describe ingress [ingress-name]
```

https://www.terraform.io/intro/index.html
https://learn.hashicorp.com/tutorials/terraform/gke?in=terraform/kubernetes
https://github.com/hashicorp/learn-terraform-provision-gke-cluster