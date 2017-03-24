# Deployment for Prometheus, Grafana and Telegraf
This is deployment Prometheus, Grafana and Telegraf with Ansible.

**NOT FULLY READY YET**


## Introduction
* This deployment scenarios created for monitoring the big kubernetes
cluster
* Deployment has
  * prometheus-sys.example.com - Prometheus for system metrics
  * prometheus-k8s.example.com - Prometheus for Kubernetes metrics also
  using as Grafana server
  * k8s.example.com - main Kubernetes node
  * several kubernetes nodes (not need to configure it getting from
  cluster in _deploy_telegraf.sh_ script)
* **The deployment absolutely unsecure**
  * Telegraf deployed without authorization and https
* Tested on Kubernetes cluster with 400 hardware nodes
* The both Prometheuses tuned for 400 Kubernetes nodes on servers with
256G RAM


## Grafana
Examples of Grafanas dashboards you can find [here](https://grafana.com/sergeygalkin)


## Manual steps
1. Build telegraf binary and put to ./scripts
1. Change hosts file to your needs (set both Prometheus servers)
1. Change hosts and Kubernetes login/password in
[prometheus-kuber.yml.j2](./prometheus/prometheus-kuber.yml.j2)
1. Change login, password, nodes and main etherent defice in
[deploy_telegraf.sh](./deploy_telegraf.sh)
1. If you have servers with Intel Processor Counter Monitor (PCM) support
build memory tool as described in
[this document](./scripts/intel_pcm_mem/HOWTO_BUILD.md)
