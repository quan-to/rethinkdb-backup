#!/bin/bash

url='http://rancher-metadata/2015-12-19'
ENV_NAME=${ENV_NAME:-$(curl -s $url/self/stack/environment_name)}
ENV_NAME=`echo ${ENV_NAME} | sed 's/ /_/g'`
STACK_NAME=${STACK_NAME:-$(curl -s "$url/self/service/stack_name")}
STACK_NAME=${STACK_NAME:-"default"}
RETHINK_HOST=${RETHINK_HOST:-"db"}
RETHINK_PORT=${RETHINK_PORT:-28015}
BUCKET_NAME=${BUCKET_NAME:-"backup"}

AWS_ACCESS_KEY=$(cat /run/secrets/AWS_ACCESS_KEY)
AWS_ACCESS_SECRET=$(cat /run/secrets/AWS_ACCESS_SECRET)

BKP_NAME="${STACK_NAME}-`date +"%Y%m%d_%H%M%S"`.tar.gz"

S3_FILE="s3://${BUCKET_NAME}/${ENV_NAME}/${STACK_NAME}/"

echo "Setting up AWS Credentials"

mkdir ~/.aws/
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = ${AWS_ACCESS_KEY}
aws_secret_access_key = ${AWS_ACCESS_SECRET}

EOF

echo "Starting backup for stack ${STACK_NAME} from ${RETHINK_HOST} at ${S3_FILE}${BKP_NAME}"

rethinkdb-dump -c ${RETHINK_HOST}:${RETHINK_PORT} -f ${BKP_NAME}

echo "Uploading it to S3"

aws s3 cp "${BKP_NAME}" "${S3_FILE}"

echo "Done"