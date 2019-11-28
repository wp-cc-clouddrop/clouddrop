# README

This is Dockerfile for deployment docker image used in CI/CD. It combines following images/tools:

- azure-cli Docker image
- google-cloud-sdk
- kubectl

For interactive bash console, run with: `docker run -it clouddrop/deploy`

## Google Cloud SDK auth

Auth using service account, tutorial [here](https://circleci.com/docs/2.0/google-auth/)

## Choose deployment

Deployment are chosen from Gitlab CI variable. Setting either `DEPLOY_GCP` or `DEPLOY_AZURE` to `1` will deploy to corresponding target. Setting both variable to `1` will return error.