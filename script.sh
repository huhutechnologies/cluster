# based on ~/dev/gke_on_acg/
# create an environment on ACG 
open https://app.pluralsight.com/hands-on/playground/cloud-sandboxes
# click on GCloud
# get Service Account Credentials and paste here
touch sa.json

read -r -d '' SA < sa.json

gcloud init 

# open in another incognito browser
# select playground object
########## NOT ALLOWED BY ACG Project ########
# # select region europe-west4-a (15)
# REGION=europe-west4
###########

# select region us-central1-a (8)
REGION=us-central1
ZONE=$REGION-a 

PROJECT_ID=$(echo $SA | jq '.project_id' -r)
SA_EMAIL=$(echo $SA | jq '.client_email' -r)
CLUSTER_NAME=simo-cluster

# Artifact Registry name
GC_ARTIFACT_REGISTRY=test-registry

# enable APIs
gcloud services enable sourcerepo.googleapis.com container.googleapis.com cloudbuild.googleapis.com secretmanager.googleapis.com --project $PROJECT_ID

# set tf variables
rm *.tfstate* terraform.tfvars 
echo 'project_id = "'${PROJECT_ID}'"' > terraform.tfvars
echo 'acg_sa_email = "'${SA_EMAIL}'"' >> terraform.tfvars
echo 'cluster_name = "'${CLUSTER_NAME}'"' >> terraform.tfvars
echo 'region = "'${REGION}'"' >> terraform.tfvars
echo 'gc_artifact_registry = "'${GC_ARTIFACT_REGISTRY}'"' >> terraform.tfvars

# login to gcloud
gcloud auth application-default login

# Create a Cloud Source Repository for the application to build

REPO_NAME="quickstart-docker"
gcloud source repos create $REPO_NAME --project=$PROJECT_ID

# Clone the empty repository
mkdir -p ./tmp/repo-setup
cd ./tmp/repo-setup
gcloud source repos clone $REPO_NAME --project=$PROJECT_ID

# Copy application/terraform-module content to the repository
cp -r ../../../application/terraform-module/$REPO_NAME/* $REPO_NAME/

# Commit and push the content
cd $REPO_NAME
git add .
git commit -m "Initial commit of quickstart-docker content"
git push origin main

cd ../../../

# Get the repository URI for use with the Cloud Build trigger
REPO_URI="projects/$PROJECT_ID/locations/$REGION/repositories/$REPO_NAME"
echo 'repo_uri = "'${REPO_URI}'"' >> terraform.tfvars


terraform init
terraform plan
terraform apply


# login

gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
CONTEXT=$(kubectl config current-context)