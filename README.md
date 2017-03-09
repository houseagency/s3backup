# S3 Backuper

This script will make a backup of all your S3 buckets, from multiple AWS
accounts.

## How to do it

### 1. Create IAM profile(s)

Your IAM profile only needs the AmazonS3ReadOnlyAccess policy.

### 2. Add the AWS access key to the `credentials` file

The `credentials` file should be one pair of Access key ID and Secret access
key per row, separated by semicolon.

	<access_key_id>:<secret_access_key>

### 3. Violà!

Now, just run the script!

The script will loop through the credentials in your `credentials` file
and sync all your buckets to the `data/` subdirectory.

	./backup.sh

