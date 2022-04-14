#!/bin/bash

set -e

create_vc() {
    LOCATION=$(curl -X GET "${CDP_PVC_URL}/authenticate/login" \
    --insecure -i | sed -E -n 's/location:(.*)/\1/p')
    ACCOUNT_ID=$(echo ${LOCATION} | sed -E -n 's/.*accountId=(.*)&idpConnectorId.*/\1/p')
    CONNECTOR_ID=$(echo ${LOCATION} | sed -E -n 's/.*idpConnectorId=(.*)&idpConnectorType.*/\1/p')

    CDP_PVC_COOKIE=$(curl -X POST "${CDP_PVC_URL}/authenticate/callback/ldap?accountId=${ACCOUNT_ID}&idpConnectorId=${CONNECTOR_ID}" \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode "username=${CDP_PVC_USERNAME}" \
    --data-urlencode "password=${CDP_PVC_PASSWORD}" \
    --insecure -i | sed -E -n 's/set-cookie:(.*)/\1/p')
    SESSION_TOKEN=$(echo ${CDP_PVC_COOKIE} | sed -E -n 's/cdp-pvt-session-token=([^;]*); .*/\1/p')

    curl -L -X POST "${CDP_PVC_URL}/dex/api/v1/cluster/${BASE_CLUSTER_ID}/instance" \
    -H 'Content-Type: application/json' \
    -H "Cookie: cdp-pvt-session-token=${SESSION_TOKEN}" \
    --data-raw "{
        \"name\": \"${VC_NAME}\",
        \"config\":
        {
            \"properties\":
            {
                \"livy.ingress.enabled\": \"true\"
            },
            \"chartValueOverrides\": {
                \"dex-app\": {
                    \"dexapp.storage.storagePvcSize\": \"${VC_PVC_SIZE}\",
                    \"livy.storage.livyStatePvcSize\": \"${VC_PVC_SIZE}\",
                    \"safari.storage.safariPvcSize\": \"${VC_PVC_SIZE}\",
                    \"airflow.logsPersistence.size\": \"${VC_PVC_SIZE}\",
                    \"airflow.persistence.size\": \"${VC_PVC_SIZE}\"
                }
            }
        }
    }" \
    --insecure
}

main() {
    if [ $# -eq 0 ]
    then
        echo -e "No arguments supplied\nUsage: $0 -n <vc-cluster-name> -b <base-cluster-id> -s <pvc-size> -h <cdp-host-url> -u <cdp-user-name> -p <cdp-user-password>\nExample: $0 -n vc-xhu-21 -b cluster-69h4sckx -s 5Gi -h https://console-cdp1234.apps.shared-os-dev-01.kcloud.cloudera.com -u dexuser1 -p Mysecret"
        exit 1
    fi

    while getopts "n:b:s:h:u:p:" options
    do
        case ${options} in
            (n)
                VC_NAME=${OPTARG}
                ;;
            (b)
                BASE_CLUSTER_ID=${OPTARG}
                ;;
            (s)
                VC_PVC_SIZE=${OPTARG}
                ;;
            (h)
                CDP_PVC_URL=${OPTARG}
                ;;
            (u)
                CDP_PVC_USERNAME=${OPTARG}
                ;;
            (p)
                CDP_PVC_PASSWORD=${OPTARG}
                ;;
            (?)
                exit 1
                ;;
        esac
    done

    if [ -z "${VC_NAME}" ]; then
        echo "Missing virtual cluster name. Use -n to specify the virtual cluster name..."
        exit 1
    elif [ -z "${BASE_CLUSTER_ID}" ]; then
        echo "Missing base cluster id. Use -b to specify the base cluster id..."
        exit 1
    elif [ -z "${CDP_PVC_URL}" ]; then
        echo "Missing cdp host url. Use -h to specify the cdp host url..."
        exit 1
    elif [ -z "${CDP_PVC_USERNAME}" ]; then
        echo "Missing cdp user name. Use -u to specify the cdp user name..."
        exit 1
    elif [ -z "${CDP_PVC_PASSWORD}" ]; then
        echo "Missing cdp user password. Use -p to specify the cdp user password..."
        exit 1
    elif [ -z "${VC_PVC_SIZE}" ]; then
        echo "Missing pvc size. Use -s to specify the pvc size..."
        exit 1
    fi
    create_vc
}

main "$@"
exit 0