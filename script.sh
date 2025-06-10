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
echo https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=$PROJECT_ID

# enable Kubernetes Engine API
rm *.tfstate* terraform.tfvars 
echo 'project_id = "'${PROJECT_ID}'"' > terraform.tfvars
echo 'acg_sa_email = "'${SA_EMAIL}'"' >> terraform.tfvars
echo 'cluster_name = "'${CLUSTER_NAME}'"' >> terraform.tfvars
echo 'region = "'${REGION}'"' >> terraform.tfvars
gcloud auth application-default login

terraform init
terraform plan
terraform apply

# module

# login

gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
CONTEXT=$(kubectl config current-context)