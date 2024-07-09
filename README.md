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

## Available Charts

- [Envoy](charts/envoy/README.md)