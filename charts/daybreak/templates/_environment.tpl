{{- define "daybreak.environment" -}}
env:
  - name: DAYBREAK_MAINTENANCE
    value: {{ .Values.daybreak.maintenance | quote }}
  - name: DAYBREAK_BIND_ADDR
    value: ":{{ .Values.service.port }}"
  - name: DAYBREAK_MODE
    value: {{ .Values.daybreak.mode | quote }}
  - name: DAYBREAK_LOG_LEVEL
    value: {{ .Values.daybreak.logLevel | quote }}
  - name: DAYBREAK_CONSOLE_LOG
    value: {{ .Values.daybreak.consoleLog | quote }}
  - name: DAYBREAK_ORIGIN
    value: {{ .Values.daybreak.origin | quote }}
  - name: DAYBREAK_ALLOW_ORIGINS
    value: {{ .Values.daybreak.origin | quote }}
  - name: DAYBREAK_DATABASE_URL
    {{- include "daybreak.secretValue" .Values.daybreak.databaseURL | nindent 4 }}
  - name: GOOGLE_CLIENT_ID
    {{- include "daybreak.secretValue" .Values.daybreak.google.clientID | nindent 4 }}
  - name: GOOGLE_CLIENT_SECRET
    {{- include "daybreak.secretValue" .Values.daybreak.google.clientSecret | nindent 4 }}
  - name: DAYBREAK_AUTH_ALLOWED_DOMAINS
    value: {{ include "comma" .Values.daybreak.auth.allowedDomains | quote }}
  - name: DAYBREAK_AUTH_SESSION_KEY
    {{- include "daybreak.secretValue" .Values.daybreak.auth.sessionKey | nindent 4 }}
  {{- if .Values.regioninfo.enabled }}
  {{- include "regioninfo.environment" . | nindent 2 }}
  {{- end }}
{{- end -}}