test:
	terraform init
	terraform get -update
	terraform plan

deploy:
	terraform init
	terraform get -update
	terraform apply
	terraform remote push
