{{/*
Expand the name of the chart.
*/}}
{{- define "daybreak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "daybreak.fullname" -}}
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
{{- define "daybreak.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "daybreak.labels" -}}
helm.sh/chart: {{ include "daybreak.chart" . }}
{{ include "daybreak.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "daybreak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "daybreak.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
All volume mounts for the daybreak service
*/}}
{{- define "daybreak.volumeMounts" -}}
volumeMounts:
  {{- include "daybreak.volumeMounts.database" . | nindent 2 }}
{{- end }}

{{/*
Volume mounts for the sqlite3 database
*/}}
{{- define "daybreak.volumeMounts.database" -}}
- name: {{ include "daybreak.fullname" . }}-database
  mountPath: {{ .Values.storage.database.mountPath }}
{{- end }}

{{- define "daybreak.hostname" -}}
{{ trimSuffix "/" (trimPrefix "https://" (trimPrefix "http://" .Values.daybreak.origin)) }}
{{- end -}}
