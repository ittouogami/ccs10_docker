IPADDRESS=$(ip addr show $( netstat -rn | grep UG | awk -F' ' '{print $8}') \
    | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
    | grep -o [0-9].*)
docker image build \
    --rm \
    --build-arg IP=${IPADDRESS} \
    --build-arg CCS_VER=10.0.0.00010 \
    --no-cache \
    -t ccs10 .
