#!/bin/bash
# Configures pip to use our private package repo. Requires you to have set up AWS credentials prior to running this.
aws codeartifact login --tool pip --domain aed-dev --repository aed-dev --region us-west-2