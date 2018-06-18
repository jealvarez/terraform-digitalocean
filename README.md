# **Virtual Machine**

## Requirements

* [DigitalOcean](http://digitalocean.com/) Account

* Terraform v0.11.7+

## Deployment

* Generate a `ssh-key` into `ssh-keys` folder

```ssh
ssh-keygen -t rsa -C root
```

* Generate Digital Ocean Token

<img src="./docs/images/digitalocean_api_tokens_1.jpg " width="100%" height="500" />

<img src="./docs/images/digitalocean_api_tokens_2.jpg " width="50%" height="300" />

* Copy the token and set it to `digitalocean_token` variable into `variables.tf`

* Creating the infrastructure

```ssh
terraform init
terraform apply
```