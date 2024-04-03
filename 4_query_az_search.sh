
source config.sh

AZ_SEARCH_ADMIN_KEY=$(az search admin-key show -g $az_rg_name --service-name $az_search_service_name --query primaryKey -o tsv)

echo "Search index"
curl -s -X POST "https://$az_search_service_name.search.windows.net/indexes/$az_search_index_name/docs/search?api-version=$az_search_api_version" \
     -H "Content-Type: application/json" \
     -H "api-key: $AZ_SEARCH_ADMIN_KEY"  \
     -d '{
          "search": "trx",
          "queryType": "simple",
          "searchMode": "all",
          "count": true,
          "facets": ["rating,sort:count"]
     }' | jq '.["@search.facets"]'