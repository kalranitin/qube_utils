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
workspace=$7
envType=$8
envId=$9
tenant=${10}
provider=${11}

mkdir -p $deploymentArtifactsFolder

cp -R ${deploymentTemplate}/* ${deploymentArtifactsFolder}
pwd
tree ${deploymentTemplate}/
tree ${deploymentArtifactsFolder}
sed -i.bak "s#%gcr.io/image:version%#${imageTag}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%namespace%#${deploymentNS}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%appName%#${appName}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%deploymentName%#${deploymentName}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%envType%#${envType}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%envId%#${envId}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%tenant%#${tenant}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%envProvider%#${provider}#" ${deploymentArtifactsFolder}/*.yaml

# if [ $deploymentTemplate == "qube_qubeship_apis" ] || [ $deploymentTemplate == "qube_external_app_v1" ] ; then
cp $workspace/qube.yaml ${deploymentArtifactsFolder}/
spiff merge ${deploymentArtifactsFolder}/env_merge_template.yaml ${deploymentArtifactsFolder}/qube.yaml > ${deploymentArtifactsFolder}/result_env.yaml
sed -ibak 's#- {}$##g' ${deploymentArtifactsFolder}/result_env.yaml
spruce merge --prune meta --prune ports --prune service_type --prune environment_variables ${deploymentArtifactsFolder}/result_env.yaml ${deploymentArtifactsFolder}/kube-nonservice-resources.template.yaml > ${deploymentArtifactsFolder}/kube-nonservice-resources.yaml
spruce merge --prune meta --prune ports --prune service_type --prune environment_variables ${deploymentArtifactsFolder}/result_env.yaml ${deploymentArtifactsFolder}/kube-service-resources.template.yaml > ${deploymentArtifactsFolder}/kube-service-resources.yaml
# fi
kubectl version
kubectl --namespace=${deploymentNS} apply -f ${deploymentArtifactsFolder}/kube-nonservice-resources.yaml --record
kubectl --namespace=${deploymentNS} apply -f ${deploymentArtifactsFolder}/kube-service-resources.yaml --record

