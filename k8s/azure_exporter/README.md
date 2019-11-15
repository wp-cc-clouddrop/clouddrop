# README

To be used with `azure_metrics_exporter` golang CLI tools. See [repo](https://github.com/RobustPerception/azure_metrics_exporter) for intructions how to fill the config.

Each files defines metrics of resources to be scrape for each user (dennis, fazel, aiman). To get the .yaml config to use with `azure-metrics-exporter`` use the following command with the respective ConfigMap: 

```bash
kubectl get configmap azure-exporter-cfg -o "jsonpath={.data['fazel']}"
```

NOTE!! The file will be mounted to the pods as k8s ConfigMaps. That means, updating file here only will not change anything. The ConfigMaps must also be updated.

NOTE: Azure Monitor limits to 1200 requests per hour so use low scrape rate in Prometheus.
