local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/kube-prometheus-anti-affinity.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-managed-cluster.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-node-ports.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-static-etcd.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-thanos-sidecar.libsonnet') +
  {
    _config+:: {
      namespace: 'monitoring',
    },
    prometheus+::{
      prometheus+: {
        spec+: {
          serviceMonitorSelector+: {
              'key': 'app-monitor',
              'operator': 'In',
              'values': ['spring', 'golang', 'azure-exporter'],
          },
        },
      },
      serviceMonitorSpring: {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'ServiceMonitor',
        metadata: {
          labels: {'app-monitor': 'spring'},
          name: 'spring-servicemonitor',
          namespace: 'default',
        },
        spec: {
          jobLabel: 'spring',
          endpoints: [
            {
              port: 'web',
              path: '/actuator/prometheus',
            },
          ],
          selector: {
            matchLabels: {
              app: 'spring'
            },
          },
        },
      },
      serviceMonitorGolang: {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'ServiceMonitor',
        metadata: {
          labels: {'app-monitor': 'golang'},
          name: 'golang-servicemonitor',
          namespace: 'default',
        },
        spec: {
          jobLabel: 'golang',
          endpoints: [
            {
              port: 'metrics',
              path: '/metrics',
            },
          ],
          selector: {
            matchLabels: {
              app: 'golang'
            },
          },
        },
      },
      serviceMonitorAzureExporter: {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'ServiceMonitor',
        metadata: {
          labels: {'app-monitor': 'azure-exporter'},
          name: 'azure-exporter-servicemonitor',
          namespace: 'default',
        },
        spec: {
          jobLabel: 'azure-exporter',
          endpoints: [
            {
              port: 'exporter',
              path: '/metrics',
              interval: '1m',
            },
          ],
          selector: {
            matchLabels: {
              app: 'azure-exporter'
            },
          },
        },
      },
    },
  };

{ ['setup/0namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor is separated so that it can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
