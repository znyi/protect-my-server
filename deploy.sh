#!/bin/bash
set -e

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)
IMAGE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/pms/phase1:latest"

aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

docker pull "$IMAGE"
docker stop protect-my-server 2>/dev/null || true
docker rm protect-my-server 2>/dev/null || true
docker run -d --name protect-my-server -p 8080:8080 "$IMAGE"