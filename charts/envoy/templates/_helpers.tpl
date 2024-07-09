{{/*
Determine the name of the app. By default this is release or release-testnet so that
the user can install multiple Envoy nodes with different release names. If the user
specifies a nameOverride it is used but suffixed with -testnet, otherwise if a
fullnameOverride is specified, it is used without any suffix.
*/}}
{{- define "envoy.name" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "envoy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create environment definition as used by the chart labels.
*/}}
{{- define "envoy.trisaLabels" -}}
{{- if .Values.isTestnet -}}
trisa.dev/network: testnet
trisa.dev/directory: {{ default "trisatest.net" .Values.directory }}
{{- else -}}
trisa.dev/network: mainnet
trisa.dev/directory: {{ default "vaspdirectory.net" .Values.directory }}
{{- end }}
{{- if .Values.environment }}
trisa.dev/environment: {{ .Values.environment }}
{{- end }}
{{- end }}

{{/*
Define the headless service name for the stateful set, defaults to app name
*/}}
{{- define "envoy.serviceName" -}}
{{- if .Values.serviceName -}}
{{ .Values.serviceName }}
{{- else -}}
{{- include "envoy.name" . }}
{{- end }}
{{- end }}

{{/*
Define the certificates secret name for access to the certificates
*/}}
{{- define "envoy.certificatesSecretName" -}}
{{- if .Values.certificate.secretName -}}
{{ .Values.certificate.secretName }}
{{- else -}}
{{- include "envoy.name" . }}-trisa-certificates
{{- end }}
{{- end }}

{{/*
Define the certificates name for access to the certificates mounted in the secret
*/}}
{{- define "envoy.certificateName" -}}
{{- if .Values.certificate.name -}}
{{ .Values.certificate.name }}
{{- else -}}
trisa-certificates.pem
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "envoy.labels" -}}
helm.sh/chart: {{ include "envoy.chart" . }}
{{ include "envoy.trisaLabels" . }}
{{ include "envoy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/component: node
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "envoy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "envoy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
All volume mounts for the envoy node
*/}}
{{- define "envoy.volumeMounts" -}}
volumeMounts:
  {{- include "envoy.volumeMounts.certs" . | nindent 2 }}
  {{- include "envoy.volumeMounts.nodeData" . | nindent 2 }}
{{- end }}

{{/*
Volume mounts for the certificates secret
*/}}
{{- define "envoy.volumeMounts.certs" -}}
- name: {{ include "envoy.name" . }}-certs
  mountPath: {{ .Values.certificate.mountPath }}
  readOnly: true
{{- end }}

{{/*
Volume mounts for the certificates secret
*/}}
{{- define "envoy.volumeMounts.nodeData" -}}
- name: {{ include "envoy.name" . }}-data
  MountPath: {{ .Values.storage.nodeData.mountPath }}
{{- end }}

{{/*
Volumes for the certificates secret
*/}}
{{- define "envoy.volumes" -}}
volumes:
  - name: {{ include "envoy.name" . }}-certs
    secret:
      secretName: {{ include "envoy.certificate.secret" . }}
{{- end }}

{{/*
Define the secret name for the certificates
*/}}
{{- define "envoy.certificate.secret" -}}
{{- if .Values.certificate.secretName }}
{{- .Values.certificate.secretName }}
{{- else }}
{{- include "envoy.name" . }}-certs
{{- end }}
{{- end }}