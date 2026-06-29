#!/bin/bash
set -e

dnf update -y
dnf install -y docker awscli
systemctl enable docker
systemctl start docker

aws ecr get-login-password --region "${aws_region}" | docker login --username AWS --password-stdin "${target_account_id}.dkr.ecr.${aws_region}.amazonaws.com"

docker pull "${docker_image}"
docker stop app || true
docker rm app || true

docker run -d   --name app   --restart always   -p ${container_port}:${container_port}   ${env_vars}   "${docker_image}"
