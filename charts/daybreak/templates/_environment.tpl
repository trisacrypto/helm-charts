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
    {{- if .Values.daybreak.databaseURL.secretKeyRef }}
    valueFrom:
      secretKeyRef:
        name: {{ .Values.daybreak.databaseURL.secretKeyRef.name }}
        key: {{ .Values.daybreak.databaseURL.secretKeyRef.key }}
    {{- else }}
    value: {{ .Values.daybreak.databaseURL.value | quote }}
    {{- end }}
  {{- if .Values.regioninfo.enabled }}
  {{- include "regioninfo.environment" . | nindent 2 }}
  {{- end }}
{{- end -}}