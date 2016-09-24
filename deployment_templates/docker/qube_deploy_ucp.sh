#!/bin/bash
set -e -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}/

imageTag=$1
appName=$2
endpointName=$3
endpointDomain=$4
swarmHost=$5
deploymentArtifactsFolder=$6
deploymentTemplate=$7

mkdir -p $deploymentArtifactsFolder

cp -R ${deploymentTemplate}/* ${deploymentArtifactsFolder}
pwd
tree ${deploymentTemplate}/
tree ${deploymentArtifactsFolder}
sed -i.bak "s#%dtr/image:version%#${imageTag}#" ${deploymentArtifactsFolder}/*.yml
sed -i.bak "s#%svcname%#${appName}#" ${deploymentArtifactsFolder}/*.yml
sed -i.bak "s#%endpoint_name%#${endpointName}#" ${deploymentArtifactsFolder}/*.yml
sed -i.bak "s#%endpoint_domain%#${endpointDomain}#" ${deploymentArtifactsFolder}/*.yml

export SWARM_HOST=${swarmHost}

docker-compose up -d
