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

mkdir -p $deploymentArtifactsFolder

cp -R ${deploymentTemplate}/* ${deploymentArtifactsFolder}
pwd
tree ${deploymentTemplate}/
tree ${deploymentArtifactsFolder}
sed -i.bak "s#%gcr.io/image:version%#${imageTag}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%namespace%#${deploymentNS}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%appName%#${appName}#" ${deploymentArtifactsFolder}/*.yaml
sed -i.bak "s#%deploymentName%#${deploymentName}#" ${deploymentArtifactsFolder}/*.yaml

if [ $deploymentTemplate == "qube_qubeship_apis" ]; then
cp $workspace/qube.yaml .
spiff merge ${deploymentArtifactsFolder}/env_merge_template.yaml qube.yaml > result_env.yaml
spruce merge --prune environment_variables result_env.yaml ${deploymentArtifactsFolder}/kube-nonservice-resources.template.yaml > ${deploymentArtifactsFolder}/kube-nonservice-resources.yaml
fi
sleep 300

kubectl version
kubectl --namespace=${deploymentNS} apply -f ${deploymentArtifactsFolder}/kube-nonservice-resources.yaml --record
kubectl --namespace=${deploymentNS} apply -f ${deploymentArtifactsFolder}/kube-service-resources.yaml --record

