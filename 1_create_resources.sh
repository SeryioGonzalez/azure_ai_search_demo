
source config.sh

echo "Creating directories"
mkdir $export_folder
mkdir $raw_folder
mkdir $split_folder

echo "Setting subscription to $AZURE_SUBSCRIPTION_ID"
az account set -s $AZURE_SUBSCRIPTION_ID

echo "Creating resource group $az_rg_name"
az group create -n $az_rg_name -l $location -o none

echo "Creating storage account $az_storage_account_name"
az storage account create \
    --name $az_storage_account_name \
    --resource-group $az_rg_name \
    --location $location \
    --sku Standard_LRS \
    --kind StorageV2 \
    -o none

echo "Creating storage container $az_storage_container_name"
az storage container create \
    --name $az_storage_container_name \
    --account-name $az_storage_account_name \
    -o none

echo "Creating search service $az_search_service_name"
az search service create \
    --name $az_search_service_name \
    --resource-group $az_rg_name \
    --sku Standard \
    --partition-count 1 \
    --replica-count 1 \
    -o none
