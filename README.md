# Local setup
```
docker build -t rg-ops .
docker run -p 3000:3000 rg-ops
```

# Accounts

- foocompany-shared-resources
    it's an account created with the purpose of sharing resources between the other accounts
    - s3 for terraform state management
    - dynamodb for terraform state locking
    - parameter store for secrets
    - route53 for dns management

- foocompany-development
    - app deployment account
    - ecs cluster, fargate deployment

# AWS profile configuration

`$HOME/.aws/config`

```
[profile foocompany-development]
sso_start_url = https://lobs.awsapps.com/start
sso_region = us-east-1
sso_account_id = account_id
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile foocompany-shared-resources]
sso_start_url = https://lobs.awsapps.com/start
sso_region = us-east-1
sso_account_id = account_id
sso_role_name = AdministratorAccess
region = us-east-1
output = json
```

```
aws sso login --profile foocompany-development
```

# Infrastructure setup

I used terraform as the infrastructure as code tool. The terraform code is located in the `terraform` folder.

The terraform project is structured as a monorepo that contains all the modules, account projects and the application project. For a real-life scenario those would separate repositories.

`tree -d terraform`

```
terraform               -> iac monorepo root
├── accounts            -> account projects
│   ├── development
│   └── shared-resources
├── envs                -> application projects
│   ├── dev
│   └── prod
└── modules             -> modules
    ├── *
```

# Github actions

I used github actions to build and deploy the application. The github actions are located in the `.github/workflows` folder.

During my conversation with Joel, I learned that foocompany intended to use AWS's native tooling. I chose to use github actions to show a different approach.

To use github actions securely with AWS I need to setup an OIDC authentication provider on AWS. That allows github to assume a role in AWS without any explicit credentials. With that role, github will assume a role in each account it needs access to, allowing a terraform project to access resources in multiple accounts at the same time.

e.g. reading secrets from the parameter store in the shared-resources account to deploy the app to the deployment account.

```
1. github generates oidc token
2. github assumes arn:aws:iam::984855687104:role/github
3. github runs the terraform project
4. terraform assumes arn:aws:iam::*:role/github_cross_account_role using the temporary credentials from step 2.
```


# TODO

- [x] oidc on shared-resources
- [x] cross account roles on shared-resources
- [x] cross account roles on development
- [x] setup profiles on gh actions
- [x] pipeline
- [x] clone
- [x] build
- [x] ecr 
- [x] push to ecr
- [x] ecs
- [x] task definition, service
- [x] vpc
- [x] read envs from shared-resources
- [x] set envs on service
- [x] load balancer
- [x] listener
- [x] target group
- [x] acm
- [ ] cloudfront
- [x] route53   
- [ ] encrypt traffic within the aws vpc
- [ ] restrict IAM roles

