
source config.sh

AZ_SEARCH_ADMIN_KEY=$(az search admin-key show -g $az_rg_name --service-name $az_search_service_name --query primaryKey -o tsv)
AZ_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string -n $az_storage_account_name -g $az_rg_name --query connectionString -o tsv)

echo "Creating datasources"
curl -X POST "https://$az_search_service_name.search.windows.net/datasources?api-version=$az_search_api_version" \
     -H "Content-Type: application/json" \
     -H "api-key: $AZ_SEARCH_ADMIN_KEY" \
     -d '{
           "name": "azureblob",
           "type": "azureblob",
           "credentials": { "connectionString": "'"$AZ_STORAGE_CONNECTION_STRING"'" },
           "container": { "name": "'"$az_storage_container_name"'" } 
         }' > /dev/null 2>&1

echo "Deleting index"
curl -X DELETE "https://$az_search_service_name.search.windows.net/indexes/$az_search_index_name?api-version=$az_search_api_version" \
     -H "Content-Type: application/json" \
     -H "api-key: $AZ_SEARCH_ADMIN_KEY"  

echo "Deleting indexer"
curl -X DELETE "https://$az_search_service_name.search.windows.net/indexers/$az_search_index_name?api-version=$az_search_api_version" \
     -H "Content-Type: application/json" \
     -H "api-key: $AZ_SEARCH_ADMIN_KEY"  

echo "Creating index"
curl -X POST "https://$az_search_service_name.search.windows.net/indexes?api-version=$az_search_api_version" \
     -H "Content-Type: application/json" \
     -H "api-key: $AZ_SEARCH_ADMIN_KEY" \
     -d '{
           "name": "'"$az_search_index_name"'",
           "fields": [
                {"name": "id",                "type": "Edm.String",  "key": true,  "searchable": false, "filterable": false, "sortable": false, "facetable": false, "retrievable": true },
                {"name": "rating",            "type": "Edm.Double",  "key": false, "searchable": false, "filterable": true , "sortable": true , "facetable": true , "retrievable": true },
                {"name": "title",             "type": "Edm.String",  "key": false, "searchable": true , "filterable": false, "sortable": false, "facetable": false, "retrievable": true },
                {"name": "text",              "type": "Edm.String",  "key": false, "searchable": true , "filterable": false, "sortable": false, "facetable": false, "retrievable": true },
                {"name": "asin",              "type": "Edm.String",  "key": false, "searchable": false, "filterable": false, "sortable": false, "facetable": false, "retrievable": true },
                {"name": "parent_asin",       "type": "Edm.String",  "key": false, "searchable": false, "filterable": false, "sortable": false, "facetable": false, "retrievable": true },
                {"name": "user_id",           "type": "Edm.String",  "key": false, "searchable": false, "filterable": true , "sortable": false, "facetable": false, "retrievable": true },
                {"name": "timestamp",         "type": "Edm.Double",  "key": false, "searchable": false, "filterable": false, "sortable": false, "facetable": false, "retrievable": true },
                {"name": "helpful_vote",      "type": "Edm.Double",  "key": false, "searchable": false, "filterable": true , "sortable": true , "facetable": true , "retrievable": true },
                {"name": "verified_purchase", "type": "Edm.Boolean", "key": false, "searchable": false, "filterable": true , "sortable": false, "facetable": false, "retrievable": true }
           ]
         }' > /dev/null 2>&1

echo "Creating indexer"
curl -X PUT "https://$az_search_service_name.search.windows.net/indexers/$az_search_index_name?api-version=$az_search_api_version" \
     -H "Content-Type: application/json" \
     -H "api-key: $AZ_SEARCH_ADMIN_KEY" \
     -d '{   
          "dataSourceName" : "azureblob",  
          "targetIndexName" : "'"$az_search_index_name"'",
          "parameters" : { 
               "configuration" : { 
                    "parsingMode" : "jsonLines"
               }
          }
        
     }'