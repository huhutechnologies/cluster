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
gcloud services enable container.googleapis.com cloudbuild.googleapis.com secretmanager.googleapis.com --project $PROJECT_ID

# set tf variables
rm *.tfstate* terraform.tfvars 
echo 'project_id = "'${PROJECT_ID}'"' > terraform.tfvars
echo 'acg_sa_email = "'${SA_EMAIL}'"' >> terraform.tfvars
echo 'cluster_name = "'${CLUSTER_NAME}'"' >> terraform.tfvars
echo 'region = "'${REGION}'"' >> terraform.tfvars
echo 'gc_artifact_registry = "'${GC_ARTIFACT_REGISTRY}'"' >> terraform.tfvars

# login to gcloud
gcloud auth application-default login

#######
# DO IT ONCE 
#######
# create a Github app to enable terraform pull source code in your organization
        #  Follow these steps to create a GitHub App:
        #  1. Go to your GitHub organization settings: https://github.com/organizations/huhutechnologies/settings/apps
        #  2. Click 'New GitHub App'
        #  3. Fill in the following details:
        #     - Name: Huhutechnologies-CloudBuild
        #     - Homepage URL: https://console.cloud.google.com/cloud-build/triggers?project=$PROJECT_ID
        echo https://console.cloud.google.com/cloud-build/triggers?project=$PROJECT_ID
        #     - Webhook URL: Leave blank (we're not using webhooks)
        #  4. Permissions needed:
        #     - Repository contents: Read-only
        #     - Metadata: Read-only
        #     - Pull requests: Read-only
        #  5. Subscribe to events:
        #     - Push
        #     - Pull request
        #  6. Click 'Create GitHub App'
        #  7. Note the App ID displayed on the next page
        #  8. Generate a private key by clicking 'Generate a private key'
        #  9. Install the app on your organization by clicking 'Install App'
        #  10. Select the repositories you want to use with Cloud Build
        #  11. Note the Installation ID from the URL after installation (format: /installations/INSTALLATION_ID)
        #  
        #  After completing these steps, enter the GitHub App Installation ID:
        open https://github.com/organizations/huhutechnologies/settings/apps/huhutechnologies-cloudbuild
        read GITHUB_APP_INSTALLATION_ID


        # Generate a client secret in the Github app and save the token
        echo "YOUR_OAUTH_TOKEN" > .github_app_token
#######
# DO IT ONCE - END
#######

# create a secret in GC SecretsManager for the github Oauth Token
gcloud secrets create github-token --replication-policy="user-managed" --locations=$REGION
gcloud secrets versions add github-token --data-file="./.github_app_token" 


# enable github connection for the cloudbuild module
echo 'create_connection = "true"' >> terraform.tfvars
echo 'connection_name = "Huhutechnologies-CloudBuild"' >> terraform.tfvars
echo 'github_app_installation_id = "'$GITHUB_APP_INSTALLATION_ID'"' >> terraform.tfvars
echo 'github_oauth_token_secret_version = "'$(gcloud secrets versions list github-token --uri | head -n 1 | sed 's/.*v1\///g')'"' >> terraform.tfvars



terraform init
terraform plan
terraform apply


# login

gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID
CONTEXT=$(kubectl config current-context)