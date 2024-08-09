{{/*
Compute the web bind addr from the services port if not provided elsewhere
*/}}
{{- define "envoy.webBindAddr" -}}
{{- if .Values.trisa.web.bindAddr -}}
{{ .Values.trisa.web.bindAddr }}
{{- else -}}
:{{ .Values.services.web.port }}
{{- end -}}
{{- end -}}

{{/*
Compute the grpc bind addr from the services port if not provided elsewhere
*/}}
{{- define "envoy.grpcBindAddr" -}}
{{- if .Values.trisa.node.bindAddr -}}
{{ .Values.trisa.node.bindAddr }}
{{- else -}}
:{{ .Values.services.grpc.port }}
{{- end -}}
{{- end -}}

{{/*
If the web auth audience isn't specified, use the origin
*/}}
{{- define "envoy.webAudience" -}}
{{- if .Values.trisa.web.auth.audience -}}
{{ .Values.trisa.web.auth.audience }}
{{- else -}}
{{ .Values.trisa.web.origin }}
{{- end -}}
{{- end -}}

{{/*
If the web auth issuer isn't specified, use the origin
*/}}
{{- define "envoy.webIssuer" -}}
{{- if .Values.trisa.web.auth.issuer -}}
{{ .Values.trisa.web.auth.issuer }}
{{- else -}}
{{ .Values.trisa.web.origin }}
{{- end -}}
{{- end -}}

{{/*
If the web auth cookie domain isn't specified, compute it from the origin
*/}}
{{- define "envoy.webCookieDomain" -}}
{{- if .Values.trisa.web.auth.cookieDomain -}}
{{ .Values.trisa.web.auth.cookieDomain }}
{{- else -}}
{{- $url := urlParse .Values.trisa.web.origin -}}
{{ $url.host }}
{{- end -}}
{{- end -}}


{{/*
If the path to the certificates isn't provided, compute it from the certificates values
*/}}
{{- define "envoy.nodeCerts" -}}
{{- if .Values.trisa.node.certs -}}
{{ .Values.trisa.node.certs }}
{{- else -}}
{{- if .Values.certificate.name -}}
{{ .Values.certificate.mountPath }}/{{ .Values.certificate.name }}
{{- else -}}
{{ .Values.certificate.mountPath}}/trisa-certificate.pem
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
If the path to the TRISA cert pool isn't provided, compute it from the certificates values
*/}}
{{- define "envoy.nodePool" -}}
{{- if .Values.trisa.node.pool -}}
{{ .Values.trisa.node.pool }}
{{- else -}}
{{- if .Values.certificate.name -}}
{{ .Values.certificate.mountPath }}/{{ .Values.certificate.name }}
{{- else -}}
{{ .Values.certificate.mountPath}}/trisa-certificate.pem
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
If the web auth cookie domain isn't specified, compute it from the origin
*/}}
{{- define "envoy.directoryEndpoint" -}}
{{- if .Values.trisa.directory.endpoint -}}
{{ .Values.trisa.directory.endpoint }}
{{- else -}}
{{- if .Values.isTestnet -}}
api.trisatest.net:443
{{- else -}}
api.vaspdirectory.net:443
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
If the web auth cookie domain isn't specified, compute it from the origin
*/}}
{{- define "envoy.membersEndpoint" -}}
{{- if .Values.trisa.directory.membersEndpoint -}}
{{ .Values.trisa.directory.membersEndpoint }}
{{- else -}}
{{- if .Values.isTestnet -}}
members.trisatest.net:443
{{- else -}}
members.vaspdirectory.net:443
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compute the display name of the organization
*/}}
{{- define "envoy.displayName" -}}
{{- if .Values.displayName -}}
{{ .Values.displayName }}
{{- else -}}
{{- if .Values.isTestnet -}}
{{ include "envoy.name" . | replace "-" " " | title }} TestNet
{{- else -}}
{{ include "envoy.name" . | replace "-" " " | title }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
The Envoy node is primarily configured through the environment, which is defined by the
following template and rendered from the configuration values provided by the user.
*/}}
{{- define "envoy.environment" -}}
env:
  - name: TRISA_MAINTENANCE
    value: {{ .Values.trisa.maintenance | quote }}
  - name: TRISA_ORGANIZATION
    value: {{ include "envoy.displayName" . | quote }}
  - name: TRISA_MODE
    value: {{ .Values.trisa.mode | quote }}
  - name: TRISA_LOG_LEVEL
    value: {{ .Values.trisa.logLevel | quote }}
  - name: TRISA_CONSOLE_LOG
    value: {{ .Values.trisa.consoleLog | quote }}
  - name: TRISA_DATABASE_URL
    value: {{ .Values.trisa.databaseURL | quote }}
  - name: TRISA_WEBHOOK_URL
    value: {{ .Values.trisa.webhookURL | quote }}
  - name: TRISA_ENDPOINT
    value: {{ .Values.trisa.endpoint | quote }}
  - name: TRISA_TRP_ENDPOINT
    value: {{ .Values.trisa.trp.endpoint | quote }}
  - name: TRISA_WEB_ENABLED
    value: {{ .Values.trisa.web.enabled | quote }}
  - name: TRISA_WEB_API_ENABLED
    value: {{ .Values.trisa.web.apiEnabled | quote }}
  - name: TRISA_WEB_UI_ENABLED
    value: {{ .Values.trisa.web.uiEnabled | quote }}
  - name: TRISA_WEB_BIND_ADDR
    value: {{ include "envoy.webBindAddr" . | quote }}
  - name: TRISA_WEB_ORIGIN
    value: {{ .Values.trisa.web.origin | quote }}
  - name: TRISA_WEB_DOCS_NAME
    value: {{ .Values.trisa.web.docsName | quote }}
  - name: TRISA_WEB_AUTH_KEYS
    value: ""
  - name: TRISA_WEB_AUTH_AUDIENCE
    value: {{ include "envoy.webAudience" . | quote }}
  - name: TRISA_WEB_AUTH_ISSUER
    value: {{ include "envoy.webIssuer" . | quote }}
  - name: TRISA_WEB_AUTH_COOKIE_DOMAIN
    value: {{ include "envoy.webCookieDomain" . | quote }}
  - name: TRISA_WEB_AUTH_ACCESS_TOKEN_TTL
    value: {{ .Values.trisa.web.auth.accessTokenTTL | quote }}
  - name: TRISA_WEB_AUTH_REFRESH_TOKEN_TTL
    value: {{ .Values.trisa.web.auth.refreshTokenTTL | quote }}
  - name: TRISA_WEB_AUTH_TOKEN_OVERLAP
    value: {{ .Values.trisa.web.auth.tokenOverlap | quote }}
  - name: TRISA_NODE_ENABLED
    value: {{ .Values.trisa.node.enabled | quote }}
  - name: TRISA_NODE_BIND_ADDR
    value: {{ include "envoy.grpcBindAddr" . | quote }}
  - name: TRISA_NODE_POOL
    value: {{ include "envoy.nodePool" . | quote }}
  - name: TRISA_NODE_CERTS
    value: {{ include "envoy.nodeCerts" . | quote }}
  - name: TRISA_NODE_KEY_EXCHANGE_CACHE_TTL
    value: {{ .Values.trisa.node.keyExchangeCacheTTL | quote }}
  - name: TRISA_NODE_DIRECTORY_INSECURE
    value: {{ .Values.trisa.directory.insecure | quote }}
  - name: TRISA_NODE_DIRECTORY_ENDPOINT
    value: {{ include "envoy.directoryEndpoint" . | quote }}
  - name: TRISA_NODE_DIRECTORY_MEMBERS_ENDPOINT
    value: {{ include "envoy.membersEndpoint" . | quote }}
  - name: TRISA_DIRECTORY_SYNC_ENABLED
    value: {{ .Values.trisa.directory.syncEnabled | quote }}
  - name: TRISA_DIRECTORY_SYNC_INTERVAL
    value: {{ .Values.trisa.directory.syncInterval | quote }}
  - name: TRISA_TRP_ENABLED
    value: {{ .Values.trisa.trp.enabled | quote }}
  - name: TRISA_TRP_BIND_ADDR
    value: {{ include "envoy.trpBindAddr" . | quote }}
  - name: TRISA_TRP_USE_MTLS
    value: {{ .Values.trisa.trp.useMTLS | quote }}
  - name: TRISA_TRP_POOL
    value: {{ .Values.trisa.trp.pool | quote }}
  - name: TRISA_TRP_CERTS
    value: {{ .Values.trisa.trp.certs | quote }}
  {{- if .Values.regioninfo.enabled }}
  {{- $configMap := default "region-info" .Values.regioninfo.configMap }}
  - name: REGION_INFO_ID
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_ID
  - name: REGION_INFO_NAME
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_NAME
  - name: REGION_INFO_COUNTRY
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_COUNTRY
  - name: REGION_INFO_CLOUD
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_CLOUD
  - name: REGION_INFO_CLUSTER
    valueFrom:
      configMapKeyRef:
        name: {{ $configMap }}
        key: REGION_INFO_CLUSTER
  {{- end }}
{{- end }}