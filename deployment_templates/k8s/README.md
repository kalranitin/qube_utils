k8s
	app_template_id
		kube-nonservice-resources
		kube-service-resources


./qube_deploy_k8s.sh gcr.io/qubeship/qube-swagger-registry:latest production qube-swagger-registry qube-swagger-registry-deployment /tmp/deployment/deploymentTemplate-prod-production-qube-swagger-registry-deployment-3 qube_external_app_v1 ~/Dev/git/qubeship/qube-api-registry prod k8s1 qubeship k8s