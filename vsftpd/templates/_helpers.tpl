{{- define "metadata.name" -}}
name: {{ print .Chart.Name "-" .Release.Name | trunc 63 }}
{{- end -}}

{{- define "metadata.common" -}}
{{ include "metadata.name" . }}
namespace: {{ print .Release.Namespace }}
labels: {{ include "metadata.labels" . | nindent 2 }}
{{- end -}}

{{- define "metadata.labels.name" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end -}}
{{- define "metadata.labels" -}}
{{ include "metadata.labels.name" . }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "deployment.image" -}}
{{ printf "%s:%s" (required "Image repository must be defined." .Values.image.repository) (.Values.image.tag | default "latest")}}
{{- end -}}