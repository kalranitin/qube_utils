#!/bin/bash
set -e -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}/

imageTag=$1
deploymentNS=$2
appName=$3
deploymentName=$4
deploymentArtifactsFolder=$5
deploymentTemplate=$6

mkdir -p $deploymentArtifactsFolder

cp -R ${deploymentTemplate}/ ${deploymentArtifactsFolder}
sed -i.bak 's#%gcr.io/image:version%#${imageTag}#' ${deploymentArtifactsFolder}/*.yaml
sed -i.bak 's#%namespace%#${deploymentNS}#' ${deploymentArtifactsFolder}/*.yaml
sed -i.bak 's#%appName%#${appName}#' ${deploymentArtifactsFolder}/*.yaml
sed -i.bak 's#%deploymentName%#${deploymentName}#' ${deploymentArtifactsFolder}/*.yaml

kubectl version
kubectl --namespace=${deploymentNS} apply -f ${deploymentArtifactsFolder}/kube-nonservice-resources.yaml --record
kubectl --namespace=${deploymentNS} apply -f ${deploymentArtifactsFolder}/kube-service-resources.yaml --record
