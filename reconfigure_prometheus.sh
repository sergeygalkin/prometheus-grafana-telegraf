#!/bin/bash
ansible-playbook -i ./hosts ./deploy-graf-prom.yaml --tags "prometheus-conf" --skip-tags "always"
