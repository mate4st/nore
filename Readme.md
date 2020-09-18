# Nore
Terraform project for docker management in addition to ansible for raspberry pi's

Run: `terraform apply -var-file=secrets.tfvars`

### Backend

We use S3 as backend type. There are several ways to authenticate in AWS.

I use a default profile located in ``$HOME/.aws/credentials``.

````
[default]
region=eu-central-1
aws_access_key_id=
aws_secret_access_key=
````
