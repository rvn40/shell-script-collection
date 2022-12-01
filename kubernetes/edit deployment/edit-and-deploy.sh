#!/bin/bash
 
declare localdir="k8s-manifests/1.23/staging"

# Declare a string array with type
declare -a localnameservices=("analytics-service" "analytics-producer-service" "cache-getter-service" "campaign-getter-service" "campaign-management-service" "campaign-redisearch-getter-service" "comment-participant-service" "form-module-participant" "frame-module-service" "frame-module-generator" "module-service" "server-apps-service" "twibbonize-account-service" "twibbonize-marketplace-service" "twibbonize-notification-service")

declare -a clusternameservices=("analytics-api" "analytics-producer-api" "cache-getter-api" "campaign-getter-api" "campaign-management-api" "campaign-redisearch-getter-api" "comment-participant-api" "form-module-participant-api" "frame-module-api" "frame-module-generator-api" "module-api" "server-apps-api" "twibbonize-account-api" "twibbonize-marketplace-api" "twibbonize-notification-api")
 
# Update local deployment manifest
for val in "${localnameservices[@]}"; do
  sed -i "s/SpotMediumLoadNodeGroup01/TwibCloudAppsSpotNGPrivate01/g" $PWD/$val/$localdir/deployment.yaml
  sed -i "s/cpu: \"1\"/cpu: 200m/g" $PWD/$val/$localdir/deployment.yaml
  sed -i "s/memory: \"1Gi\"/memory: 200Mi/g" $PWD/$val/$localdir/deployment.yaml
done

echo "Local Done!! Waiting for deployment...."
sleep 3

# Implement to deployment in cluster
for val in "${clusternameservices[@]}"; do
  kubectl get deploy $val -n twb-stg-twbapps-01 -o yaml > editdeploymentspec .yaml && sed -i "s/SpotMediumLoadNodeGroup01/TwibCloudAppsSpotNGPrivate01/g" editdeploymentspec .yaml && kubectl replace -f editdeploymentspec .yaml
  kubectl get deploy $val -n twb-stg-twbapps-01 -o yaml > editdeploymentspec .yaml && sed -i "s/cpu: \"1\"/cpu: 200m/g" editdeploymentspec .yaml && kubectl replace -f editdeploymentspec .yaml
  kubectl get deploy $val -n twb-stg-twbapps-01 -o yaml > editdeploymentspec .yaml && sed -i "s/memory: \"1Gi\"/memory: 200Mi/g" editdeploymentspec .yaml && kubectl replace -f editdeploymentspec .yaml 
done


