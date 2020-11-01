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


#### Minio

`mc admin user add minio ACCESS_KEY_ID SECRET_ACCESS_KEY`

`mc admin group add minio name user`

`mc admin policy add minio plolicy_name policy.json`

`mc admin policy set minio policy_name group=somegroup`

**Example policy:**

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:*"
          ],
          "Resource": [
            "arn:aws:s3:::bucket/*"
          ]
        }
      ]
    }
