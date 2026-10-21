{{- define "regioninfo.environment" -}}
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
- name: REGION_INFO_ZONE
  valueFrom:
    configMapKeyRef:
      name: {{ $configMap }}
      key: REGION_INFO_ZONE
- name: REGION_INFO_CLUSTER
  valueFrom:
    configMapKeyRef:
      name: {{ $configMap }}
      key: REGION_INFO_CLUSTER
{{- end -}}
