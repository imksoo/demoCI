test:
	@echo start terraform plan in $(CURDIR)
	terraform init -get=true
	terraform get -update
	terraform plan
	@echo end terraform plan in $(CURDIR)

deploy:
	@echo start terraform apply in $(CURDIR)
	terraform apply
	@echo end terraform apply in $(CURDIR)
