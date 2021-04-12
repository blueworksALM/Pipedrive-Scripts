#!/bin/bash
workingDirectory=$(pwd)

inputFile="$workingDirectory/ids.txt"
outputFile="$workingDirectory/addresses.txt"

read -r -p "Specify email ID file location: " inputFileOverride
echo "The email ID file is located: " "$inputFile"

echo "The email ID file is located: " "$outputFile"
touch "$outputFile"

echo "please enter your pipedrive API Token: "
read -s -r apiToken

echo "Starting data extraction"
while IFS= read -r email;
do
	requestUrl=""
	messageId="${email}"
			requestUrl="https://api.pipedrive.com/v1/mailbox/mailMessages/${messageId}?api_token=${apiToken}"
			echo "Loading email $messageId"
			returnBody=$(curl -s -X GET "$requestUrl")
			emailAddress=$(jq -r '.data.to[] | {email_address:.email_address} | .email_address' <<< "${returnBody}")
			echo "Data extracted. Email $messageId associated to $emailAddress"
			echo "Saving email address to Output file..."
			echo "$emailAddress" >> "$outputFile"
			messageId=""
			sleep 0.7
done < "$inputFile"

echo "Data extraction ended"
exit
