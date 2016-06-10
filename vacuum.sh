#!/bin/bash

vault="test-vacuum"
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

if [[ -z $inputarchivedescription ]]
then
	archivedescription="$file.tar.gz"
else
	archivedescription="$file.tar.gz - $inputarchivedescription"
fi

read -p "Encrypt with GPG? y/N: " inputencrypt

if [[ $inputencrypt == "y" ]]
then
    tarfile="temp-sinkhole-$(date +%s).tar.gz.gpg"
    echo "tar czv $file | gpg -c > $tarfile"
    tar czv $file | gpg -c > $tarfile
else
    tarfile="temp-sinkhole-$(date +%s).tar.gz"
    echo "tar czvf $tarfile \"$file\""
    tar czvf "$tarfile" "$file"
fi

echo aws glacier upload-archive --vault-name $vault --account-id - --archive-description \"$archivedescription\" --body $tarfile
aws glacier upload-archive --vault-name $vault --account-id - --archive-description "$file.tar.gz" --body $tarfile

echo rm $tarfile
rm $tarfile
