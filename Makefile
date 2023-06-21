PHONY: build push
build:
	docker build --platform linux/amd64 . -t rg-ops:local

push: build
	aws ecr get-login-password --profile foocompany-development --region us-east-1 | docker login --username AWS --password-stdin 984855687104.dkr.ecr.us-east-1.amazonaws.com
	docker tag rg-ops:local 984855687104.dkr.ecr.us-east-1.amazonaws.com/rg-ops:development
	docker push 984855687104.dkr.ecr.us-east-1.amazonaws.com/rg-ops:development

apply-dev:
	terraform fmt -recursive .
	terraform -chdir=./terraform/envs/dev  apply -auto-approve
