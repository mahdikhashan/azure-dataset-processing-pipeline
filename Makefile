CURRENT_DIR:=$(shell pwd)

AZ_RESOURCE_GROUP="azure-project"
AZ_LOCATION="germanywestcentral"

# copied from az-get-subscription-id
AZ_SUBSCRIPTION_ID="ae26c860-c4bc-4c0e-80d5-dc36838062f1"
AZ_MANAGED_IDENTITY_NAME="mysuperduperid"

AZ_KEY_VAULT="mykvforjkuazproject2"

AZ_BATCH_ACCOUNT_NAME="mysupercoolbatchaccount"
# format https://AZ_BATCH_ACCOUNT_NAME.AZ_LOCATION.batch.azure.com
AZ_BATCH_ACCOUNT_URL="https://mysupercoolbatchaccount.germanywestcentral.batch.azure.com"

AZ_BATCH_ENDPOINT=$(az batch account show --name $AZ_BATCH_ACCOUNT_NAME --resource-group $AZ_RESOURCE_GROUP --query "accountEndpoint" --output tsv)

AZ_DATAFACTORY_NAME="my-jku-project-data-factory"

AZ_STORAGE_ACCOUNT="mypipelinestorageaccount"
AZ_STORAGE_CONTAINER_RAW="raw"
AZ_STORAGE_CONTAINER_OUT="out"
AZ_STORAGE_CONTAINER_SCRIPTS="scripts"


debug:
	echo "in debugging step"
	az batch account show --name $(AZ_BATCH_ACCOUNT_NAME) --resource-group $(AZ_RESOURCE_GROUP) --query "accountEndpoint" --output tsv

debug-files-extracted-in-blob:
	az storage blob list --account-name $(AZ_STORAGE_ACCOUNT) --container-name $(AZ_STORAGE_CONTAINER_OUT) --prefix "ext/images/" --query "length(@)" --output tsv --auth-mode login

az-config:
	az config set extension.dynamic_install_allow_preview=true
	az config set extension.use_dynamic_install=yes_without_prompt

az-login:
	az login

az-create-resource-group:
	az group create --name $(AZ_RESOURCE_GROUP) --location $(AZ_LOCATION)

az-create-datafactory:
	az datafactory create --resource-group $(AZ_RESOURCE_GROUP) --factory-name $(AZ_DATAFACTORY_NAME) --debug

az-create-storage-account:
	az storage account create \
      --name $(AZ_STORAGE_ACCOUNT) \
      --resource-group $(AZ_RESOURCE_GROUP) \
      --location $(AZ_LOCATION) \
      --sku Standard_LRS \
      --encryption-services blob

az-create-storage-container:
	az storage container create --name $(AZ_STORAGE_CONTAINER_RAW) --account-name $(AZ_STORAGE_ACCOUNT) --auth-mode login
	az storage container create --name $(AZ_STORAGE_CONTAINER_OUT) --account-name $(AZ_STORAGE_ACCOUNT) --auth-mode login
	az storage container create --name $(AZ_STORAGE_CONTAINER_SCRIPTS) --account-name $(AZ_STORAGE_ACCOUNT) --auth-mode login

az-create-batch-account:
	az batch account create --name $(AZ_BATCH_ACCOUNT_NAME) --resource-group $(AZ_RESOURCE_GROUP) --location $(AZ_LOCATION) --storage-account $(AZ_STORAGE_ACCOUNT)

az-add-pool-to-batch-account:
	az batch pool create --account-name $(AZ_BATCH_ACCOUNT_NAME) --json-file infra/batch/pool/mypool.json --account-endpoint https://$(AZ_BATCH_ACCOUNT_NAME).$(AZ_LOCATION).batch.azure.com

	bash -c 'until az batch pool show \
        		--account-name $(AZ_BATCH_ACCOUNT_NAME) \
        		--account-endpoint https://$(AZ_BATCH_ACCOUNT_NAME).$(AZ_LOCATION).batch.azure.com \
        		--pool-id mypool \
        		--query "allocationState" -o tsv | grep -q "steady"; do \
        		echo "Pool is not ready yet. Waiting..."; \
        		sleep 5; \
        	done; \
        	echo "Pool is ready!"'

# old - to be deleted
#az-add-task-to-pool:
#	az batch job create --id myjob --pool-id mypool

debug-az-list-adf-linked-service:
	az datafactory linked-service list	--resource-group $(AZ_RESOURCE_GROUP) --factory-name $(AZ_DATAFACTORY_NAME)

debug-az-datafactory-object:
	az datafactory show --resource-group $(AZ_RESOURCE_GROUP) \
        --factory-name $(AZ_DATAFACTORY_NAME) \
        --query identity.principalId \
        -o tsv

az-get-subscription-id:
	az account show --query id -o tsv

# old - to be deleted
#az-list-identities:
#	az identity list -g $(AZ_RESOURCE_GROUP)
#
#az-create-identity:
#	az identity create \
#        --resource-group $(AZ_RESOURCE_GROUP) \
#        --name $(AZ_MANAGED_IDENTITY_NAME)
#
#az-list-subscription:
#	az account list --output table

az-deploy-adf-pipeline:
	sed -e "s/TEMP_AZ_BATCH_ACCOUNT_NAME/$AZ_BATCH_ACCOUNT_NAME/" -e "s|TEMP_AZ_BATCH_ACCOUNT_URL|$AZ_BATCH_ACCOUNT_URL|" -e "s/TEMP_AZ_BATCH_ORCHESTRATOR_POOL_ID/$AZ_BATCH_ORCHESTRATOR_POOL_ID/" infra/adf/linkedService/azurebatch_ls.json > infra/adf/linkedService/temp_azurebatch_ls.json
	sed -e "s|<your-keyvault-name>|$(AZ_KEY_VAULT)|g" infra/adf/linkedService/akv_ls.json > infra/adf/linkedService/temp_akv_ls.json

	jq . infra/adf/linkedService/temp_akv_ls.json

	az datafactory linked-service create --debug --resource-group $(AZ_RESOURCE_GROUP) \
		--factory-name $(AZ_DATAFACTORY_NAME) \
		--linked-service-name "AzureBlobStorage_LS" \
		--properties infra/adf/linkedService/azurebatchstorage_ls.json

	az datafactory linked-service create --resource-group $(AZ_RESOURCE_GROUP) \
		--factory-name $(AZ_DATAFACTORY_NAME) \
		--linked-service-name "AzureBatch_LS" \
		--properties infra/adf/linkedService/temp_azurebatch_ls.json

	az datafactory pipeline create --resource-group $(AZ_RESOURCE_GROUP) \
		--factory-name $(AZ_DATAFACTORY_NAME) \
		--pipeline-name "sample-pipeline" \
		--pipeline infra/adf/pipeline/pipeline.json
