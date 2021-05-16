{{- define "metadata.name" -}}
name: {{ print .Chart.Name "-" .Release.Name | trunc 63 }}
{{- end -}}

{{- define "metadata.namespace" -}}
namespace: {{ print .Release.Namespace }}
{{- end -}}

{{- define "metadata.common" -}}
{{ include "metadata.name" . }}
{{ include "metadata.namespace" . }}
labels: {{ include "metadata.labels" . | nindent 2 }}
{{- end -}}

{{- define "metadata.labels.name" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end -}}
{{- define "metadata.labels" -}}
{{ include "metadata.labels.name" . }}
app.kubernetes.io/version: {{ coalesce .Chart.AppVersion .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "deployment.image" -}}
{{ printf "%s:%s" (required "Image repository must be defined." .Values.image.repository) (.Values.image.tag | default "latest")}}
{{- end -}}

{{- define "deployment.image.pullpolicy" -}}
{{- if .Values.image.pullPolicy }}
imagePullPolicy: {{ .Values.image.pullPolicy }}
{{- end }}
{{- end -}}

{{- define "deployment.image.pullsecrets" -}}
{{ if .Values.image.pullSecrets }}
imagePullSecrets: 
{{- range .Values.image.pullSecrets }}
- {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "pasvcontainerports" -}}
{{- if eq .Values.vsftpd.mode.passive.enabled true }}
{{- range untilStep (int .Values.vsftpd.mode.passive.startPort) (int (add1 .Values.vsftpd.mode.passive.endPort)) (int 1) }}  
- containerPort: {{ . }}
{{- end }}
{{- end }}
{{- end -}}


{{- define "service.pasvports" -}}
{{- if eq .Values.vsftpd.mode.passive.enabled true }}
{{- range untilStep (int .Values.vsftpd.mode.passive.startPort) (int (add1 .Values.vsftpd.mode.passive.endPort)) (int 1) }}  
- protocol: TCP
  port: {{ . }}
  targetPort: {{ . }}
  name: {{printf "app-port-%d" . }}
{{- end }}
{{- end }}
- protocol: TCP
  port: 21
  targetPort: 21
  name: "data"
- protocol: TCP
  port: 20
  targetPort: 20
  name: "command"
{{- end -}}

{{- define "service.httpports" -}}
- protocol: TCP
  port: 80
  targetPort: 80
{{- end -}}

{{- define "service.http.metadata" -}}
name: {{ print "http-" .Chart.Name "-" .Release.Name | trunc 63 }}
{{ include "metadata.namespace" .}}
labels: 
  app.kubernetes.io/component: http
{{- include "metadata.labels" . | nindent 2}}
{{- end -}}

{{- define "service.ftp.metadata" -}}
name: {{ print "ftp-" .Chart.Name "-" .Release.Name | trunc 63 }}
{{ include "metadata.namespace" .}}
labels: 
  app.kubernetes.io/component: ftp
{{- include "metadata.labels" . | nindent 2}}
{{- end -}}