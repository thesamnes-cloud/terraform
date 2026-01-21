version: 0.2

env:
  variables:
    TF_VERSION: "1.6.6"

phases:
  install:
    commands:
      - curl -s https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o terraform.zip
      - unzip terraform.zip
      - mv terraform /usr/local/bin/
  pre_build:
    commands:
      - terraform --version
      - terraform init -input=false
  build:
    commands:
      - terraform plan -input=false
  post_build:
    commands:
      - terraform apply -auto-approve -input=false
