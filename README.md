# TRISA Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/trisacrypto)](https://artifacthub.io/packages/search?repo=trisacrypto)

Helm charts for Kubernetes deployment of TRISA services.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add trisacrypto https://helm.trisa.dev

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
trisacrypto` to see the charts.

Prerequisites:

1. You've applied for and recieved TRISA certificates from vaspdirectory.net
2. You've decrypted your certificates using your PKCS12 password
3. You've provisioned the DNS names specified in the certificates

To install the Envoy chart for your testnet:

    helm install vaspname trisacrypto/envoy \
      --set isTestnet=true \
      --set trisa.endpoint=testnet.vaspname.com \
      --set trisa.web.origin=https://envoy.vaspname.com \
      --set certificate.name=testnet.vaspname.com.pem
      --set certificate.data=$(base64 -i ./secrets/testnet.vaspname.com.pem)

To uninstall the chart:

    helm uninstall vaspname