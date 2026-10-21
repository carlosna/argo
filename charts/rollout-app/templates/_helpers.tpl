{{- define "rollout-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rollout-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "rollout-app.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "rollout-app.stableServiceName" -}}
{{- printf "%s-stable" (include "rollout-app.fullname" . | trunc 56 | trimSuffix "-") }}
{{- end }}

{{- define "rollout-app.canaryServiceName" -}}
{{- printf "%s-canary" (include "rollout-app.fullname" . | trunc 56 | trimSuffix "-") }}
{{- end }}

{{- define "rollout-app.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
app.kubernetes.io/name: {{ include "rollout-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Values.partOf | quote }}
{{- end }}

{{- define "rollout-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rollout-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "rollout-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rollout-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "rollout-app.image" -}}
{{- if .Values.image.digest -}}
{{ printf "%s@%s" .Values.image.repository .Values.image.digest }}
{{- else -}}
{{ printf "%s:%s" .Values.image.repository .Values.image.tag }}
{{- end -}}
{{- end }}

{{- define "rollout-app.revision" -}}
{{- if .Values.image.digest -}}
{{- .Values.image.digest | trunc 63 | trimPrefix "sha256:" -}}
{{- else -}}
{{- .Values.image.tag | trunc 63 -}}
{{- end -}}
{{- end }}

{{- define "rollout-app.gatewayRef" -}}
{{- if .Values.istio.gateway.namespace -}}
{{ printf "%s/%s" .Values.istio.gateway.namespace .Values.istio.gateway.name }}
{{- else -}}
{{ .Values.istio.gateway.name }}
{{- end -}}
{{- end }}

