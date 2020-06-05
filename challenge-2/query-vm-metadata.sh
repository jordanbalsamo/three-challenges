SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo
echo "This script returns the name of a given VM on a given cloud provider."
echo "Please ensure you have authenticated to your chosen cloud provider, prior to running this script."
echo "Choose a cloud provider (azure / aws / gcp):"
read cloudProvider

#Limit user input to Azure/AWS/GCP
if [[ $cloudProvider =~ ^(azure|aws|gcp)$ ]]; then
    echo "Target cloud provider: $cloudProvider."

    #Get instance identifer.
    echo "Please provide the instance identifer:"
    read instanceIdentifier

    #If user input is empty, inform and quit.
    if [[ -z $instanceIdentifier ]]; then
        echo "Identifier cannot be null."
        exit 1
    fi

    #Depending on chosen cloud provider, execute relevant CLI command.
    #For sake of simplicity, this script uses a dummy-data.json file to emulate the CLI output.
    #Links to cloud provider docs for chosen CLI commands.
    case $cloudProvider in

        azure)
            echo "Azure VM metadata for $instanceIdentifier:"
            
            cat $SCRIPTPATH/dummy-data.json
            #az vm show --ids "$instanceIdentifier" --output json
            #https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-show
            ;;

        aws)
            echo "AWS VM metadata for $instanceIdentifier:"
            cat $SCRIPTPATH/dummy-data.json
            #aws ec2 describe-instances --instance-ids "$instanceIdentifier" --output json
            #https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html
            
            ;;

        gcp)
            echo "GCP VM metadata for $instanceIdentifier:"
            cat $SCRIPTPATH/dummy-data.json
            #gcloud compute instances list --filter="id:$instanceIdentifier" --format="json"
            #https://cloud.google.com/sdk/gcloud/reference/compute/instances/list
            ;;

        *)
            echo "Not supported."
            exit 1
            ;;
    esac
else
    echo "Invalid cloud provider."
    exit 1
fi





