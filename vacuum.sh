#!/bin/bash

vault="test"
file=$@

if [[ -z $@ ]]
then
	echo Empty arguments, exiting
	exit
fi

if [[ ! -r $@ ]]
then 
	echo "File doens't exist or is not readable"
fi

read -p "Archive description (optional): " inputarchivedescription

read -p "Encrypt with GPG? y/N: " inputencrypt

if [[ $inputencrypt == "y" ]]
then
    file_extension="tar.gz.gpg"
    processed_file="temp-sinkhole-$(date +%s).$file_extension"
    echo "tar czv $file | gpg -c > $processed_file"
    tar czv "$file" | gpg -c > "$processed_file"
else
    file_extension="tar.gz"
    processed_file="temp-sinkhole-$(date +%s).$file_extension"
    echo "tar czvf $processed_file \"$file\""
    tar czvf "$processed_file" "$file"
fi

if [[ -z $inputarchivedescription ]]
then
	archivedescription="$file.$file_extension"
else
	archivedescription="$file.$file_extension - $inputarchivedescription"
fi

echo aws glacier upload-archive --vault-name $vault --account-id - --archive-description \"$archivedescription\" --body $processed_file
aws glacier upload-archive --vault-name $vault --account-id - --archive-description "$archivedescription" --body $processed_file

echo rm $processed_file
rm $processed_file
