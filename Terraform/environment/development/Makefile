test:
	$(info ---Terraform test start---)
	$(info terraform init)
	terraform init -get=true
	$(info terraform get)
	terraform get -update
	$(info terraform plan)
	terraform plan
	$(info ---Terraform test end--)

deploy:
	$(info ---Terraform deploy start---)
	$(info terraform init)
	terraform init -get=true
	$(info terraform get)
	terraform get -update
	$(info terraform apply)
	terraform apply
	$(info terraform remote push)
	terraform remote push
	$(info ---Terraform deploy end---)
