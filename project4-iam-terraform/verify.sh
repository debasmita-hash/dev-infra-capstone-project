#!/usr/bin/env bash

set -euo pipefail

mkdir -p evidence

USER_NAME="$(terraform output -raw iam_user_name)"
USER_ARN="$(terraform output -raw iam_user_arn)"
POLICY_ARN="$(terraform output -raw iam_policy_arn)"

echo "=============================================="
echo "Project 4 IAM verification"
echo "=============================================="
echo "User:       ${USER_NAME}"
echo "User ARN:   ${USER_ARN}"
echo "Policy ARN: ${POLICY_ARN}"
echo

echo "[1/5] Verifying IAM user..."

aws iam get-user \
  --user-name "${USER_NAME}" \
  --output json |
  tee evidence/01-iam-user.json

echo
echo "[2/5] Verifying attached policy..."

aws iam list-attached-user-policies \
  --user-name "${USER_NAME}" \
  --output json |
  tee evidence/02-attached-policies.json

echo
echo "[3/5] Testing account-level S3 read permission..."

aws iam simulate-principal-policy \
  --policy-source-arn "${USER_ARN}" \
  --action-names s3:ListAllMyBuckets \
  --resource-arns "*" \
  --query 'EvaluationResults[].{Action:EvalActionName,Decision:EvalDecision}' \
  --output table |
  tee evidence/03-list-buckets-allowed.txt

echo
echo "[4/5] Testing bucket and object read permissions..."

aws iam simulate-principal-policy \
  --policy-source-arn "${USER_ARN}" \
  --action-names \
    s3:ListBucket \
    s3:GetBucketLocation \
    s3:GetObject \
  --resource-arns \
    "arn:aws:s3:::project4-verification-bucket" \
    "arn:aws:s3:::project4-verification-bucket/example.txt" \
  --query 'EvaluationResults[].{Action:EvalActionName,Resource:EvalResourceName,Decision:EvalDecision}' \
  --output table |
  tee evidence/04-read-actions.txt

echo
echo "[5/5] Testing S3 write and delete permissions..."

aws iam simulate-principal-policy \
  --policy-source-arn "${USER_ARN}" \
  --action-names \
    s3:CreateBucket \
    s3:PutObject \
    s3:DeleteObject \
    s3:DeleteBucket \
  --resource-arns \
    "arn:aws:s3:::project4-verification-bucket" \
    "arn:aws:s3:::project4-verification-bucket/example.txt" \
  --query 'EvaluationResults[].{Action:EvalActionName,Resource:EvalResourceName,Decision:EvalDecision}' \
  --output table |
  tee evidence/05-write-actions-denied.txt

echo
echo "=============================================="
echo "Verification completed"
echo "=============================================="
echo "Expected:"
echo "  Applicable read operations: allowed"
echo "  Write/delete operations:    implicitDeny"
echo
echo "Evidence files:"
find evidence -maxdepth 1 -type f -printf '%f\n' | sort
