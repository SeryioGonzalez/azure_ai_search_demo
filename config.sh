
prefix="sergiosearch"
location="switzerlandnorth"

az_rg_name=$prefix"_rg"
az_search_service_name=$prefix"-search"
az_search_index_name="reviews"
az_search_api_version="2023-11-01"
az_storage_account_name=$prefix"storage"
az_storage_container_name="reviews"

export_folder="data/"
raw_folder=$export_folder"raw/"
split_folder=$export_folder"split/"

export_file_name="dataset.raw.json"
export_file=$raw_folder$export_file_name
split_file_prefix=$split_folder"dataset_"

max_file_size=134217728

# Intended for bash and python scripts. Put no spaces between the equal sign and the value.
#dataset_name="Sleoruiz/discursos-completos-etiquetados"
dataset_name="McAuley-Lab/Amazon-Reviews-2023"
dataset_config_name="raw_review_Sports_and_Outdoors"
dataset_split="full"
dataset_undesired_column_0="images"
