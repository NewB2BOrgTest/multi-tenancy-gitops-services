#!/usr/bin/env bash

# Set variables
if [[ -z ${CC_DB_PASSWORD} ]]; then
  echo "Please provide environment variable CC_DB_PASSWORD"
  exit 1
fi
if [[ -z ${ADMIN_USER_PASSWORD} ]]; then
  echo "Please provide environment variable ADMIN_USER_PASSWORD"
  exit 1
fi
if [[ -z ${JMS_PASSWORD} ]]; then
  echo "Please provide environment variable JMS_PASSWORD"
  exit 1
fi
if [[ -z ${KEYSTORE_PASSWORD} ]]; then
  echo "Please provide environment variable KEYSTORE_PASSWORD"
  exit 1
fi
if [[ -z ${TRUSTSTORE_PASSWORD} ]]; then
  echo "Please provide environment variable TRUSTSTORE_PASSWORD"
  exit 1
fi
if [[ -z ${EMAIL_PASSWORD} ]]; then
  echo "Please provide environment variable EMAIL_PASSWORD"
  exit 1
fi
if [[ -z ${USER_KEY} ]]; then
  echo "Please provide environment variable USER_KEY"
  exit 1
fi

CC_DB_PASSWORD=${CC_DB_PASSWORD}
ADMIN_USER_PASSWORD=${ADMIN_USER_PASSWORD}
JMS_PASSWORD=${JMS_PASSWORD}
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD}
TRUSTSTORE_PASSWORD=${TRUSTSTORE_PASSWORD}
EMAIL_PASSWORD=${EMAIL_PASSWORD}
USER_KEY=${USER_KEY}

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml
oc create secret generic ibm-sccm-secret --type=Opaque \
--from-literal=.ccDBPassword=${CC_DB_PASSWORD} \
--from-literal=.adminUserId=admin \
--from-literal=.adminUserPassword=${ADMIN_USER_PASSWORD} \
--from-literal=.trustStorePassword=${TRUSTSTORE_PASSWORD} \
--from-literal=.keyStorePassword=${KEYSTORE_PASSWORD} \
--from-literal=.emailPassword=${EMAIL_PASSWORD} \
--from-literal=.jmsUserId=app \
--from-literal=.jmsPassword=${JMS_PASSWORD} \
--from-literal=.userKey=${USER_KEY} \
--dry-run=client -o yaml > delete-ibm-sccm-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n sccm --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-ibm-sccm-secret.yaml > ibm-sccm-secret.yaml

# NOTE, do not check delete-ibm-sccm-secret.yaml into git!
rm delete-ibm-sccm-secret.yaml
