#!/bin/bash

source settings.sh

increment_ip() {
    # IP address format is '.'
    IFS='.' read -ra ADDR <<< "$1"
    # Increment the last octet
    last_octet=$((ADDR[-1] + 1))
    # Reconstruct IP address with incremented last octet
    echo "${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.$last_octet"
}


# Generate static worker hosts
STATIC_WORKERS_HOSTS=""
current_ip=$BASE_IP
for i in $(seq 1 $WORKERS_NUMBER); do
    # Increment IP for each worker
    if [[ $i -gt 1 ]]; then # Skip increment for the first worker
        current_ip=$(increment_ip $current_ip)
    fi
    STATIC_WORKERS_HOSTS+="  - privateAddress: '${current_ip}'\n"
    STATIC_WORKERS_HOSTS+="    sshUsername: 'root'\n"
    STATIC_WORKERS_HOSTS+="    sshPrivateKeyFile: '${PRIVATE_SSH_KEY}'\n"
done

# Render the template
TEMPLATE_FILE="template/k1_template.yaml"
OUTPUT_FILE="kubeone.yaml"
sed -e "s|{{ STATIC_WORKERS_HOSTS }}|$STATIC_WORKERS_HOSTS|g" \
    -e "s|{{ CONTROLPLANE_PRIVATE_ADDRESS }}|$CONTROLE_PLANE_IP|g" \
    -e "s|{{ CONTROLPLANE_SSH_USERNAME }}|root|g" \
    -e "s|{{ CONTROLPLANE_SSH_PRIVATE_KEY }}|$PRIVATE_SSH_KEY|g" \
    -e "s|{{ KUBERNETES_VERSION }}|$K8S_VERSION|g" \
    -e "s|{{ CLUSTER_NAME }}|$CLUSTER_NAME|g" \
    "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "Rendered template saved to $OUTPUT_FILE"
