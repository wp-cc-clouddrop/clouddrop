# README

To be used with `azure_metrics_exporter` golang CLI tools. See [repo](https://github.com/RobustPerception/azure_metrics_exporter) for intructions how to fill the config.

Each files defines metrics of resources to be scrape for each user (dennis, fazel, aiman).

NOTE: Azure Monitor limits to 1200 requests per hour so use low scrape rate in Prometheus.
