locals {
  # Network reference
  external_domain = data.kubernetes_config_map.network_context.data.external_domain
  external_ingress_ip = data.kubernetes_config_map.network_context.data.external_ingress_ip

  pod_network_cidr = data.kubernetes_config_map.network_context.data.pod_network_cidr
  service_network_cidr = data.kubernetes_config_map.network_context.data.service_network_cidr
  cluster_domain = data.kubernetes_config_map.network_context.data.cluster_domain

  cluster_issuer_enabled = tobool(data.kubernetes_config_map.network_context.data.cert_manager_cluster_issuer_enabled)
  cluster_issuer_name = data.kubernetes_config_map.network_context.data.cert_manager_cluster_issuer_name

  dns_records_proxy_enabled = tobool(data.kubernetes_config_map.network_context.data.dns_records_proxy_enabled)
  dns_records_default_comment = data.kubernetes_config_map.network_context.data.dns_records_default_comment
  dns_ttl_seconds = tonumber(data.kubernetes_config_map.network_context.data.dns_ttl_seconds)

  ingress_class_name = data.kubernetes_config_map.network_context.data.primary_ingress_class_name

  storage_class_name = data.kubernetes_config_map.storage_context.data.primary_storage_class_name
}

locals {
  # Kubernetes Dashboard configuration
  kubernetes_dashboard_enabled = true
  kubernetes_dashboard_namespace = "kubernetes-dashboard"
  kubernetes_dashboard_ingress_class_name = local.ingress_class_name
  kubernetes_dashboard_ingress_host_address = "dashboard.k8s.${local.external_domain}"
  kubernetes_dashboard_chart_linting_enabled = true
  kubernetes_dashboard_ingress_annotations = local.cluster_issuer_enabled ? {
    "cert-manager.io/cluster-issuer" = local.cluster_issuer_name
  } : {}

  create_dns_records = true
}
