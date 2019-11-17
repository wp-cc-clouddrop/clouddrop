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

      prometheus+:: {
        namespaces+:: ['linkerd'],
      },
    },
    prometheus+::{
      prometheus+: {
        spec+: {
          serviceMonitorSelector+: {'app-monitor': 'azure-exporter', 'k8s-app': 'linkerd-prometheus'},
        },
      },
      serviceMonitorLinkerdPrometheus: {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'ServiceMonitor',
        metadata: {
          labels: {
            'k8s-app': 'linkerd-prometheus',
            'release': 'monitoring',
          },
          name: 'linkerd-federate',
          namespace: 'linkerd',
        },
        spec: {
          jobLabel: 'app',
          endpoints: [
            {
              interval: '30s',
              scrapeTimeout: '30s',
              params: {
                'match[]': [
                  '{job="linkerd-proxy"}',
                  '{job="linkerd-controller"}',
                ],
              },
              path: '/federate',
              port: 'admin-http',
              honorLabels: true,
              relabelings: [
                {
                  action: 'keep',
                  regex: '^prometheus$',
                  sourceLabels: [
                    '__meta_kubernetes_pod_container_name',
                  ],
                },
              ],
            },
          ],
          namespaceSelector: {
            matchNames: ['linkerd'],
          },
          selector: {
            matchLabels: {
              'linkerd.io/control-plane-component': 'prometheus',
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
