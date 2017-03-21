test:
	terraform init -get=true
	terraform get -update
	terraform plan

deploy:
	terraform init -get=true
	terraform get -update
	terraform apply
	terraform remote push
