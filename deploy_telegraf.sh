#!/bin/bash
set -e
export ANSIBLE_HOST_KEY_CHECKING=False
export SSH_USER="root"
export SSH_PASS="password"
cd $(dirname $(realpath $0))

PROMETHEUS_NODE=${PROMETHEUS_NODE:-prometheus-k8s.example.com}
KUBE_MAIN_NODE="k8s.example.com"
MAIN_ETH_DEV="eth0"

# Secret option
ANSIBLE_TAG=$2

SSH_OPTS="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

echo "Get clusters nodes"

NODES_TMP=$(sshpass -p ${SSH_PASS} ssh ${SSH_OPTS} ${SSH_USER}@${KUBE_MAIN_NODE} 'kubectl get nodes -o jsonpath='"'"'{.items[*].status.addresses[?(@.type=="InternalIP")].address}'"'"'')
KUBER_NODE_IP=$(sshpass -p ${SSH_PASS} ssh ${SSH_OPTS} ${SSH_USER}@${KUBE_MAIN_NODE} ip -4 addr show dev ${MAIN_ETH_DEV} | grep intet | awk '{print $2}' | awk -F'/' '{print $1}')

SSH_AUTH="ansible_ssh_user=${SSH_USER} ansible_ssh_pass=${SSH_PASS}"
echo "Generate inventory for kubernetes cluster"
echo "[main]" > cluster-hosts
echo "${PROMETHEUS_NODE} ${SSH_AUTH}" >> cluster-hosts
echo "[main-kuber]" >> cluster-hosts
echo "${KUBE_MAIN_NODE} ${SSH_AUTH}" >> cluster-hosts
echo "[cluster-nodes]" >> cluster-hosts
set +e
# Remove IP of kuber main nodes
for i in ${NODES_TMP} ; do
    TMP_VAR=$(echo $i | grep -vE "(${KUBER_NODE_IP})")
    NODES="${NODES} ${TMP_VAR}"
done
set -e
for i in ${NODES} ; do
    if [ "$i" != "${KUBE_MAIN_NODE}" ]; then
        echo "${i} ${SSH_AUTH}" >>  cluster-hosts
    fi
done
echo "[all-cluster-nodes:children]" >> cluster-hosts
echo "main-kuber" >> cluster-hosts
echo "cluster-nodes" >> cluster-hosts
LINES=$(wc -l cluster-hosts | awk '{print $1}')
NUM_NODES=$(($LINES - 7))
if [ ${NUM_NODES} -le 0 ]; then
   echo "Something wrong, $NUM_NODES nodes found"
   exit 1
else
   echo "${NUM_NODES} nodes found"
fi

if [ -z "${ANSIBLE_TAG}" ]; then
   ansible-playbook -f 40 -i ./cluster-hosts  ./deploy-telegraf.yaml
else
   ansible-playbook -f 40 -i ./cluster-hosts -t ${ANSIBLE_TAG} ./deploy-telegraf.yaml
fi
