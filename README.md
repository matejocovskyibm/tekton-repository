# Tekton and Argo CD Pipelines

## Install OpenShift Pipelines Operator

1. Go to OperatorHub and search for `OpenShift Pipelines`

2. Install with the default settings

## Create Secrets for your Pipeline

1. Create a user with Push/Pull access in Gogs

2. Workloads > Secrets > Create > Source Secrets

> - Name = {Any name you like}
> - Authentication Type = Basic Authentication
> - Username = {Username of created User}
> - Password = {Password of created User}

3. Annotate the Secret.

> - On the Secret in the console click Actions > Edit Annotations.
> - set KEY to: tekton.dev/git-0
> - set VALUE to: {Git Repo Host}

4. Link the password to the Service Account `Running the pipeline

```
oc secrets link <Service Account Name> <Secret name>
```

## Apply the Pipeline yamls

oc apply -f {tekton-folder}/Pipeline -n {namespace to deploy pipeline}

oc apply -f {tekton-folder}/Tasks -n {namespace to deploy pipeline}

oc apply -f {tekton-folder}/Webhooks -n {namespace to deploy pipeline}

## Expose EventListener Service

```
oc expose svc {name of EventListener Service}
```

## Add Webhook to Gogs

1. Go to Networking > Routes

2. Copy The URL of the EventListener Route That triggers your required Pipeline

3. Go to Gogs

4. Go To the Repo you want to add a webhook to

5. Click Settings > Webhooks > Add Webhook

6. Paste EventListener Route in Payload URL

7. Click Add Webhook

## Install Argo CD Operator

We are using the Argo CD community Operator via OperatorHub

1. Go to OperatorHub and search for `Argo CD`

2. Select the Operator called "Argo CD" (Not Argo CD Operator (Helm)).

3. Select which namespace to install Argo CD onto. e.g. argo

4. Click Subscribe

## Install an Argo CD Instance

Ensure you are in the namespace where you have installed Argo CD

```
oc apply -f Argocd/ArgoCD.yaml
```

## Create ArgoCD Application

1. Go to Networking > Routes

2. Click on the url of the `argocd-server` Route

3. Click the Login via OpenShift Button.

### Add a GitOps Repo to Argo CD

4. Click Manage your repositories, projects, settings

5. Click Repositories

6. Click Connect Repo using HTTPS

7. Provide, URL, Username and Passowrd

8. Click Connect

### Deploy your GitOps Repo

1. Click New App

2. Apply the following setting:

> - Application Name = {The Name of Your App}
> - Project = default
> - Sync Policy = Automatic
> - Repository URL = URL of the GitOps Repo
> - Revision = HEAD
> - Path = {Path to manifests folder e.g. manifests/app-name}
> - Cluster URL = https://kubernetes.default.svc
> - Namespace = {OpenShift project you want to deploy the application}

3. Click Create

### Allow Argo to make changes to application namespace

```
oc policy add-role-to-user edit system:serviceaccount:{Namespace where Argo CD is deployed}:argocd-application-controller -n {namespace where application is deployed}
```
