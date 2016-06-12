# vacuum
Bash script to compress, encrypt and upload files or directories to AWS Glacier

# Dependancies

1. tar
2. gpg (optional)
3. AWS Command Line Interface
   - Install instructions http://docs.aws.amazon.com/cli/latest/userguide/installing.html

# How to use

## AWS user permissions

You need to create a AWS user with permissions for your desired vault, if you plan on leaving your AWS CLI with these credentials, I would suggest only adding the upload permission as some may be potentially abused by someone.

Configure the CLI using the ID and secret keys from the user  http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

## Configure script

At the top of the file there is a variable "vault" to choose which vault to upload to, default is "vacuum".

## Upload

The script takes one argument, the file. All other options such as the archive description and whether to encrypt interactive.
```
[~/repos/MarvelousChris]$ ./vacuum.sh vacuum
Archive description (optional): Vacuum backup script
Encrypt with GPG? y/N: y
tar czv vacuum | gpg -c > temp-sinkhole-1465581896.tar.gz.gpg
vacuum/
vacuum/LICENSE
vacuum/README.md
vacuum/vacuum.sh
aws glacier upload-archive --vault-name test --account-id - --archive-description "vacuum.tar.gz - Vacuum backup script" --body temp-sinkhole-1465581896.tar.gz.gpg
{
    "archiveId": "k4LJETQBKgqL2igsXsgiKS2tO40OfaJCVm2V41niTu6XfBfZ0JqT4FhIvrCZHcoWEiOYOirSsw2Mt1og8_G3sEOwhaA84E1MU-bJ9CgyHp32qWOzZZZasdDDbuI7w2PVAnI3xhgOsr_A", 
    "checksum": "2cd2947fba538f1a108ce4e22c77401cde71c50eaed8f5fc91ccc111b21885d5", 
    "location": "/4711258160/vaults/test/archives/k4LJETQBKgqL2igsXXsgiKS2tO40OfaJCVm2V41niTu6XfBfZ0JqT4FhIvrCZHcoWEiOYOirSsw2Mt1og8_G3sEOwhaA84E1MU-bJ9CgyHp32qWOzZZZasdDDbuI7w2PVAnI3xhgOsr_A"
}
rm temp-sinkhole-1465581896.tar.gz.gpg```


#### Potential todos
1. Handle more than one file
2. Multipart upload (to save space when processing)


