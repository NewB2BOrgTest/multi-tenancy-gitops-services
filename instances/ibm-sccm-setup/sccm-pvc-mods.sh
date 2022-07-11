#!/usr/bin/env bash

NS="sccm"
RWX_STORAGECLASS=${RWX_STORAGECLASS:-managed-nfs-storage}

echo "Building PVC"
( echo "cat <<EOF" ; cat ibm-sccm-pvc.yaml_template ;) | \
RWX_STORAGECLASS=${RWX_STORAGECLASS} \
NS=${NS} \
sh > ibm-sccm-pvc.yaml

echo "Building Input PVC"
( echo "cat <<EOF" ; cat ibm-sccm-input-pvc.yaml_template ;) | \
RWX_STORAGECLASS=${RWX_STORAGECLASS} \
NS=${NS} \
sh > ibm-sccm-input-pvc.yaml

echo "Done"