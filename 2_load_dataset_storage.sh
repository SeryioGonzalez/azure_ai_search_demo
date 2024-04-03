
source config.sh
set -e
echo "Purging folder $export_folder"
find $export_folder -type f -exec rm -f {} \;

echo "Exporting dataset to $export_file"
python export_dataset.py $export_file
exit
echo "Splitting dataset"
lines_per_split_file=$(python lines_for_split.py $export_file $max_file_size)
split -d -l $lines_per_split_file $export_file $split_file_prefix --filter='cat > $FILE.json'

echo "Uploading dataset to storage account"
AZ_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string -n $az_storage_account_name -g $az_rg_name --query connectionString -o tsv)
for file in $(find $split_folder -type f); do
    az storage blob upload --account-name $az_storage_account_name --container-name $az_storage_container_name --file $file --connection-string $AZ_STORAGE_CONNECTION_STRING --overwrite
done