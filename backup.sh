#!/bin/bash
set -e
pushd "$(dirname $0)" >/dev/null
for CREDENTIALS in $(cat credentials); do
  KEYID="$(echo $CREDENTIALS | sed s/:.*$//)"
  SECRETKEY="$(echo $CREDENTIALS | sed s/^.*://)"
  BUCKETS="$(AWS_ACCESS_KEY_ID="$KEYID" AWS_SECRET_ACCESS_KEY="$SECRETKEY" aws s3 ls  | cut -f3 -d" ")"
  for BUCKET in $BUCKETS; do
    echo -e "\n==[ $BUCKET ]=================================="
    mkdir -p "data/$BUCKET"
    pushd "data/$BUCKET" >/dev/null
    REGION="$(AWS_ACCESS_KEY_ID="$KEYID" AWS_SECRET_ACCESS_KEY="$SECRETKEY" aws s3api get-bucket-location --bucket "$BUCKET" | grep LocationConstraint | grep -v null | sed 's/.*: "//' | sed 's/"$//')"
    if [ "$REGION" = "" ]; then
      REGION="us-east-1"
    fi
    AWS_ACCESS_KEY_ID="$KEYID" AWS_SECRET_ACCESS_KEY="$SECRETKEY" AWS_DEFAULT_REGION="$REGION" aws s3 sync "s3://$BUCKET/" .
    popd >/dev/null
  done
done
popd >/dev/null
