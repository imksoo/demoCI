AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID_DEV}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY_DEV}
AWS_DEFAULT_REGION=us-west-1

test:
	terraform get -update
	terraform plan

deploy:
	terraform get -update
	terraform apply
	terraform remote push
