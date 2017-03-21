test:
	@echo start terraform plan in $(CURDIR)
	terraform init -get=true
	terraform get -update
	terraform show
	terraform plan
	@echo end terraform plan in $(CURDIR)

deploy:
	@echo start terraform apply in $(CURDIR)
	terraform init -get=true
	terraform get -update
	terraform show
	terraform apply
	terraform show
	@echo end terraform apply in $(CURDIR)
