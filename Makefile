ROOT_DIR=${PWD}
SCRIPTS_DIR = ${ROOT_DIR}/scripts
KIND_SCRIPT_DIR=${ROOT_DIR}/kind-k8s/scripts

.PHONY: all
all: incremental-tasks alway-run-tasks

.PHONY: incremental-tasks
incremental-tasks: docker-images

.PHONY: alway-run-tasks  
alway-run-tasks: 

.PHONY: docker-images
docker-images: base

.PHONY: base
base:
	$(SCRIPTS_DIR)/build_base.sh

.PHONY: push
push:
	$(SCRIPTS_DIR)/push_docker_images.sh

.PHONY: clear
clear: delete-docker-images

.PHONY: delete-docker-images
delete-docker-images:
	$(SCRIPTS_DIR)/delete_local_images.sh

.PHONY: run-local
run-local:
	locust -f locustfiles/main.py

.PHONY: deploy
deploy:
	$(SCRIPTS_DIR)/deploy.sh
.PHONY: undeploy
undeploy:
	$(SCRIPTS_DIR)/undeploy.sh

.PHONY: create-kind
create-kind:
	$(KIND_SCRIPT_DIR)/create_cluster.sh
.PHONY: remove-kind
remove-kind:
	$(KIND_SCRIPT_DIR)/delete_cluster.sh

.PHONY: k8s
k8s: update-kustomize
.PHONY: update-kustomize
update-kustomize:
	$(SCRIPTS_DIR)/update_kustomize.sh

.PHONY: k8s-deploy
k8s-deploy:
	$(SCRIPTS_DIR)/deploy_k8s.sh -e ${ENV}
.PHONY: k8s-undeploy
k8s-undeploy:
	$(SCRIPTS_DIR)/undeploy_k8s.sh -e ${ENV}