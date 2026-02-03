#------------------------------------------------------------
########################### setup ###########################
#------------------------------------------------------------

# Define color variables
# 0 = Black, 1 = Red, 2 = Green, 3 = Yellow, 4 = Blue, 7 = White
BLACK_FG := $(shell tput setaf 0)
GREEN_BG := $(shell tput setab 2)
YELLOW_BG := $(shell tput setab 3)
RESET  := $(shell tput sgr0)
BOLD   := $(shell tput bold)

# Style
HEADER_START := \n=============== $(BOLD)$(BLACK_FG)$(YELLOW_BG)
HEADER_END   := $(RESET) ===============\n

#------------------------------------------------------------
############################ MISC ###########################
#------------------------------------------------------------

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: backup
backup: ## Backing up Device Configs via eos_config
	@echo -e "$(HEADER_START) Backing up Device Configs via eos_config $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags backup

.PHONY: build
build: ## Generating Device Configs - eos_designs/eos_cli_config_gen
	@echo -e "$(HEADER_START) Generating Device Configs $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags build

.PHONY: diff
diff: ## Show the diff between running config and designed config
	@echo -e "$(HEADER_START) Show the diff between running config and designed config $(HEADER_END)"
	# @ansible-playbook playbooks/deploy.yml --diff --check
	@ansible-playbook playbooks/deploy.yml --tags deploy_eapi --diff --check

.PHONY: create_tags
create_tags: ## Generating and Adding tags for Topology view
	@echo -e "$(HEADER_START) Generating and Adding tags for Topology view $(HEADER_END)"
	# @ansible-playbook playbooks/avd_create_tags.yml

#------------------------------------------------------------
######################### eosconfig #########################
#------------------------------------------------------------

.PHONY: deploy_eve_eosconfig
deploy_eve_eosconfig: ## Generating and Deploying Device Configs via eosconfig to EVENG devices
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via eosconfig to EVENG devices $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_eve_eosconfig -i inventory.yml

.PHONY: deploy_clab_eosconfig
deploy_clab_eosconfig: ## Generating and Deploying Device Configs via eosconfig to CLAB devices
	@echo -e "$(HEADER_START)  Generating and Deploying Device Configs via eosconfig to CLAB devices $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_clab_eosconfig -i inventory.yml

.PHONY: deploy_act_eosconfig
deploy_act_eosconfig: ## Generating and Deploying Device Configs via eosconfig to ACT devices
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via eosconfig to ACT devices $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_act_eosconfig -i inventory_act.yml

#------------------------------------------------------------
########################### eAPI ############################
#------------------------------------------------------------

.PHONY: deploy_eve_eapi
deploy_eve_eapi: ## Generating and Deploying Device Configs via eAPI to EVENG devices
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via eAPI to EVENG devices $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_eapi -i inventory.yml

.PHONY: deploy_clab_eapi
deploy_clab_eapi: ## Generating and Deploying Device Configs via eAPI to CLAB devices
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via eAPI to CLAB devices $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_eapi -i inventory.yml

.PHONY: deploy_act_eapi
deploy_act_eapi: ## Generating and Deploying Device Configs via eAPI to ACT devices
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via eAPI to ACT devices $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_eapi -i inventory_act.yml

#------------------------------------------------------------
######################## Cloudvision ########################
#------------------------------------------------------------

.PHONY: deploy_manifest
deploy_manifest: ## Generating and Deploying Static Device Configs via cvdeploy to CV(Manifest)
	@echo -e "$(HEADER_START) Generating and Deploying Static Device Configs via cvdeploy to CV(Manifest) $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_manifest

.PHONY: deploy_cvaas
deploy_cvaas: ## Generating and Deploying Device Configs via cvdeploy to CV(staging)
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via cvdeploy to CV(staging) $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_cvaas

.PHONY: deploy_cvaas_labs
deploy_cvaas_labs: ## Generating and Deploying Device Configs via cvdeploy to CV(labs.arista)
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via cvdeploy to CV(labs.arista) $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_cvaas_labs

.PHONY: deploy_cv_act
deploy_cv_act: ## Generating and Deploying Device Configs via cvdeploy to CV(ACT)
	@echo -e "$(HEADER_START) Generating and Deploying Device Configs via cvdeploy to CV(ACT) $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_cv_act -i inventory_act.yml

#------------------------------------------------------------
########################### CLAB ############################
#------------------------------------------------------------

.PHONY: deploy_clab
deploy_clab: ## Complete AVD & cEOS-Lab Deployment
	@echo -e "$(HEADER_START) Starting cEOS-Lab topology $(HEADER_END)"
	@sudo containerlab deploy -t topology.yml --reconfigure
    
	@echo -e "$(HEADER_START) 1-minute Wait for all devices to fully boot up $(HEADER_END)"
	@sleep 60

	@echo -e "$(HEADER_START) Building AVD Devcontainer image $(HEADER_END)"
	@devcontainer up --workspace-folder .

	@echo -e "$(HEADER_START) Generating and deploying switch configuration $(HEADER_END)"
	@devcontainer exec --workspace-folder . ansible-playbook playbooks/deploy.yml --flush-cache --tags deploy_eapi -i inventory.yml
	
	@echo -e "$(HEADER_START) cEOS-Lab Topology $(HEADER_END)"
	@sudo containerlab inspect -t topology.yml
	
	@echo -e "$(HEADER_START) cEOS-Lab Deployment Complete $(HEADER_END)"

.PHONY: destroy
destroy: ## Delete cEOS-Lab Deployment and AVD generated config and documentation
	@echo -e "$(HEADER_START) Wiping nodes and deleting AVD configuration $(HEADER_END)"
	@sudo containerlab destroy -t topology.yml --cleanup
	@rm -rf .topology.yml.bak
	@rm -rf .topology.yml.bak snapshots/ reports/ documentation/ intended/ custom_anta_catalogs/ config_backup/
	
	@echo -e "$(HEADER_START) Doing a 'git reset --hard' to Undo uncommitted changes $(HEADER_END)"
	@git reset --hard

	@echo -e "$(HEADER_START) Stopping and Removing AVD Devcontainer image $(HEADER_END)"
	@echo -e "Stopped Container image: "
	@-docker stop $$(docker ps -a | grep 'vsc-' | awk '{print $$1}')
	@sleep 10
	@echo -e "Deleted Container: "
	@-docker rm $$(docker ps -a | grep 'vsc-' | awk '{print $$1}')
	@echo -e "Removed Container image: "
	@-docker rmi $$(docker images -a | grep '^vsc-' | awk '{print $$1}')

.PHONY: inspect
inspect: ## Display cEOS-Lab Topology
	@echo -e "$(HEADER_START) cEOS-Lab Topology $(HEADER_END)"
	@sudo containerlab inspect -t topology.yml

#------------------------------------------------------------
####################### anta/validate #######################
#------------------------------------------------------------

.PHONY: validate
validate: ## Validate Configuration Deployment and Generate Device specific catalogs
	@echo -e "$(HEADER_START) Validate Configs and Generate Device specific catalogs $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags validate

.PHONY: build_nrfu
build_nrfu: ## Build ANTA inventory
	@echo -e "$(HEADER_START) Building ANTA inventory using device inventory $(HEADER_END)"
	@anta get from-ansible --ansible-inventory inventory.yml -o anta/anta_inventory_auto.yml --overwrite
	@anta get inventory --username ansible --prompt --enable -i anta/anta_inventory_auto.yml --connected

.PHONY: deploy_nrfu
deploy_nrfu: ## Build ANTA configs
	@echo -e "$(HEADER_START) Merging device specific ANTA catalogs and Running ANTA against Catalogs $(HEADER_END)"
	@python anta/merge_catalogs.py
	# @anta nrfu --username ansible --prompt -i anta/anta_inventory.yml -c  anta/anta_catalog.yml --hide success --hide skipped
	@anta nrfu --hide success --hide skipped

.PHONY: deploy_nrfu_md
deploy_nrfu_md: ## Build ANTA configs and export as Markdown
	@echo -e "$(HEADER_START) Building ANTA configs and export as Markdown $(HEADER_END)"
	@python anta/merge_catalogs.py
	@anta nrfu --username ansible --prompt -i anta/anta_inventory.yml -c  anta/anta_catalog.yml --hide success md-report --md-output anta/reports/nrfu.md

.PHONY: eos_command_output
eos_command_output: ## Build ANTA configs from eos commands and export as json and text
	@echo -e "$(HEADER_START) Building ANTA configs from eos commands and export as json and text $(HEADER_END)"
	@anta exec snapshot -u ansible --prompt -i anta/anta_inventory.yml --commands-list anta/eos_commands.yml -o anta/eos_commands_output

.PHONY: collect_techsupport
collect_techsupport: ## Collect Latest tech support file
	@echo -e "$(HEADER_START) Collect Latest tech support file $(HEADER_END)"
	@anta exec collect-tech-support -u ansible --prompt -i anta/anta_inventory.yml -o anta/tech-support --latest 1 --insecure

#------------------------------------------------------------
####################### ZTP/Onboarding ######################
#------------------------------------------------------------

.PHONY: onboard
onboard: ## Generating Cloudvision token and onboard devices to Cloudvision
	@echo -e "$(HEADER_START) 1-minute Wait for all devices to fully boot up $(HEADER_END)"
	@sleep 60

	@echo -e "$(HEADER_START) Building AVD Devcontainer image $(HEADER_END)"
	@devcontainer up --workspace-folder .
	
	@echo -e "$(HEADER_START) Generating Cloudvision token and onboard devices to Cloudvision $(HEADER_END)"
	@devcontainer exec --workspace-folder . ansible-playbook playbooks/cvaas-onboarding.yml --flush-cache

.PHONY: digital_twin
digital_twin: ## Digital Twin playbook to generate Digital Twin mode artifacts
	@echo -e "$(HEADER_START) Generating Digital Twin mode artifacts $(HEADER_END)"
	@ansible-playbook playbooks/deploy.yml --flush-cache --tags digital_twin
