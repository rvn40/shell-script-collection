#!/bin/bash
 
declare outputdir="${PWD}"
declare namespace="twb-stg-twbapps-01"

# Declare a string array with type
declare -a services=("analytics-api" "analytics-producer-api" "cache-getter-api" "campaign-getter-api" "campaign-management-api" "campaign-redisearch-getter-api" "comment-participant-api" "form-module-participant-api" "frame-module-api" "frame-module-generator-api" "module-api" "server-apps-api" "twibbonize-account-api" "twibbonize-marketplace-api" "twibbonize-notification-api")
 
# Exporting
for val in "${services[@]}"; do
  kubectl get deploy $val -n $namespace -o yaml > "${outputdir}/${val}.yaml"
done


