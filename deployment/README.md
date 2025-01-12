# Coworking Analysis tool
This Python application runs in a container and connects to the postgres backend to produce reports on the users and their activity for the coworking api microservice application.

## Building a new container version
The container images are stored in an ECR repository 855078271490.dkr.ecr.us-east-1.amazonaws.com/user3577726/coworking and are built by a Codebuild project user3577726-coworker. The build triggers automatically when changes are pushed into the main branch of the github repo (https://github.com/hamblrt/cd12355-microservices-aws-kubernetes-project-starter)

## Deploying the application
The application uses these kubernetes resources: 
  ConfigMap & Secret defining the postgres connection configurations
  Deployment and Service defining the application pods and load balancing
These are defined in the configmap.yaml and coworking.yaml files in the deployments folder in the github repository.

To deploy the application:
  1. Update the configmap.yaml with the postgres database connection configuration. NB: the database password in the secret must be base64 encoded without a trailing carriage return e.g. the output of echo -n PASSWORD | base64
  2. Update the image value in coworking.yaml with the path to the required application image
  3. First apply the configmap.yaml and then the coworking.yaml to the kubernetes cluster
  4. Verify the pod and service are created and running. If the pod is not in a running state view the pod logs to debug why (e.g. kubectl logs NAME_OF_POD).


# Resource usage
The performance and cpu/memory utilisation of the coworking pod should be monitoried e.g. using Cloudwatch and, based on the actual cpu and memory consumption over a period of time, the pod reources should be amended in the Deployment resource config in coworking.yaml to set request and limit values appropriate to what is actually being used. This prevents a runaway pod from being able to overload the node and also prevent it from being scheduled on a node that has insufficient resources to allow it to run at all. 

E.g. adding this to the Deployment's container spec:

  resources:
    limits:
      cpu: "250m"
      memory: "200Mi"
    requests:
      cpu: "100m"
      memory: "100Mi"

Will prevent the pod from using more than 0.25 cpu and 200Mb memory and prevent it from running on any node which has less than 0.1 cpu and 100Mb memory free.

According to AWS marketing the graviton processor based instances offer the best price/performance option so g type instances should be considered. Each instance type has a maximum number of pods it can support as detailed in this file https://github.com/awslabs/amazon-eks-ami/blob/main/templates/shared/runtime/eni-max-pods.txt and the cluster addons consume some of this count such that a minimal instance type e.g. t4g.micro which only allows 4 pods at maximum may not be able to run any other workloads beyond the cluster addons. 
t4g.small allows for 11 pods and m4g.medium allows for 8 so both are easily capable of supporting this application and a postgres database but the t4g instances have a lower running cost per hour (and may be free until Dec 2025 for limited use) so I built my cluster using t4g.small instances. 

## Contents of the submission

codebuild folder: contains Dockerfile and buildspec.yml for codebuild project to build the image
deployment folder: contains deployment yamls for coworking application
screenshots folder: contains screenshots as requested in the rubric