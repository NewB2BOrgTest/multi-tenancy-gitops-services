
#!/usr/bin/env bash

CLUSTER_DOMAIN=$(oc get dns cluster -o jsonpath='{ .spec.baseDomain }')

# Create Kubernetes Secret yaml
( echo "cat <<EOF" ; cat sccm-server-certificate.yaml_template ;) | \
CLUSTER_DOMAIN=${CLUSTER_DOMAIN} \
sh > sccm-server-certificate.yaml