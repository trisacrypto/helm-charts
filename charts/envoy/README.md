# TRISA Envoy

Built to help compliance teams handle travel rule exchanges efficiently and economically, Envoy is an open source, secure, peer-to-peer messaging platform. Designed by TRISA engineers and compliance experts, Envoy offers a mechanism for Travel Rule compliance by providing IVMS101 data exchanges using the TRISA and TRP protocols.

For more information please visit [Envoy's developer documentation](https://trisa.dev/envoy/index.html)

## Quick Start

Prerequisites:

1. You've applied for and recieved [TRISA certificates](https://trisa.io) from [vaspdirectory.net](https://vaspdirectory.net)
2. You've decrypted your certificates using your PKCS12 password
3. You've provisioned the DNS names specified in the certificates

To install the Envoy chart for your testnet:

```
helm install [RELEASE] trisacrypto/envoy \
    --set isTestnet=true \
    --set trisa.endpoint=testnet.vaspname.com:443 \
    --set trisa.web.origin=https://envoy.vaspname.com \
    --set certificate.name=testnet.vaspname.com.pem
    --set certificate.data=$(base64 -i ./secrets/testnet.vaspname.com.pem)
```

The placeholders above are as follows:

- `[RELEASE]`: the name of the release for helm, usually vaspname and vaspname-testnet.
- `testnet.vaspname.com:443`: the TRISA endpoint for peer-to-peer travel rule information exchanges whose domain matches those issued for your certificates.
- `https:///envoy.vaspname.com`: the URL where you would like to hose the Envoy UI and API in order to interact with the Envoy node.
- `testnet.vaspname.com.pem`: by convention, the certificate name is the name of the domain followed by the `.pem` extension.
- `./secrets/testnet.vaspname.com.pem`: path to the decrypted certificates issued to you by the Global directory service.

To uninstall the chart:

```
helm uninstall [RELEASE]
```

## Values

We strongly recommend that you manage your Envoy release configuration as YAML so that you can more easily upgrade Envoy to the latest version. For an example of a values file that we use to deploy the rVASPs, see [examples/alice.yaml].

You can then deploy your Envoy release as follows:

```
helm install alice-testnet trisacrypto/envoy -f alice.yaml \
    --set certificate.data=$(base64 -i ./secrets/testnet.vaspname.com.pem)
```

Note that we do not recommend storing or commiting your certificates with your values, which is why we recommend encoding that data on the command line when installing or upgrading your release.

## Secrets

Envoy relies on being able to load an x509 certificate issued by the TRISA Global Directory Service in order to establish secure mTLS connections with its peers. In future releases, Envoy will be able to load the certificate from a secret manager instead of directly from a file, but until that time, the certificate needs to be installed.

One option is to manage the certificate secret yourself, rather than letting Helm manage it. To do this, you would create the secret:

```
kubectl create secret generic trisa-certificates \
    --from-file=path/to/testnet.vaspname.com.pem
```

Then specify the certificate name and secret as values to helm:

```
helm install [RELEASE] trisacrypto/envoy \
    --set isTestnet=true \
    --set trisa.endpoint=testnet.vaspname.com:443 \
    --set trisa.web.origin=https://envoy.vaspname.com \
    --set certificate.name=testnet.vaspname.com.pem
    --set certificate.secretName=trisa-certificates
```

Helm will not generate or manage the secrets in this case.

The alternative is to specify the base64 encoded certificate data as `certificate.data`. In this case, helm will create and manage the secret on your behalf. In the example above, this was done by specifying the following flag:

```
--set certificate.data=$(base64 -i path/to/testnet.vaspname.com.pem)
```

This has the benefit of allowing you to have helm manage the certificate but will require you to specify the certificate data on every upgrade unless you're using tiller.

## Ingresses

Envoy requires a TLS passthrough ingress in order to operate correctly. Right now the only ingresses supported by this chart are the `traefik.io/v1alpha1` `IngressRoute` and `IngressRouteTCP` classes. Please submit a pull request if other ingresses need to be supported.
