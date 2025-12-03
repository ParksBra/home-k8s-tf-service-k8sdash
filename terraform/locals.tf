locals {
  # Network reference
  parent_domain = data.terraform_remote_state.platform_network.outputs.external_parent_domain
  cluster_issuer_enabled = data.terraform_remote_state.platform_network.outputs.cert_manager_cluster_issuer_enabled
  cluster_issuer_name = data.terraform_remote_state.platform_network.outputs.cert_manager_cluster_issuer_name

  dns_provider_api_token_infisical_secret_name = data.terraform_remote_state.platform_network.outputs.dns_provider_api_token_infisical_secret_name
  dns_records_proxy_enabled = data.terraform_remote_state.platform_network.outputs.dns_records_proxy_enabled
  dns_records_default_comment = data.terraform_remote_state.platform_network.outputs.dns_records_default_comment
  dns_ttl_seconds = data.terraform_remote_state.platform_network.outputs.dns_ttl_seconds

  ingress_class_name = data.terraform_remote_state.platform_network.outputs.primary_ingress_class_name

  storage_class_name = data.terraform_remote_state.platform_storage.outputs.primary_storage_class_name

  create_dns_records = true
}

locals {
  # Kubernetes Dashboard configuration
  kubernetes_dashboard_enabled = true
  kubernetes_dashboard_namespace = "kubernetes-dashboard"
  kubernetes_dashboard_ingress_class_name = "nginx"
  kubernetes_dashboard_ingress_host_address = "dashboard.k8s.${local.parent_domain}"
  kubernetes_dashboard_chart_linting_enabled = true
  kubernetes_dashboard_ingress_annotations = local.cluster_issuer_enabled ? {
    "cert-manager.io/cluster-issuer" = local.cluster_issuer_name
  } : {}
}
