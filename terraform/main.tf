module "kubernetes_dashboard" {
  count = local.kubernetes_dashboard_enabled ? 1 : 0
  source = "./modules/_k8sdash"
  depends_on = [
    data.kubernetes_config_map.network_context,
    data.kubernetes_config_map.storage_context
  ]

  namespace = local.kubernetes_dashboard_namespace
  create_namespace = true

  chart_linting_enabled = local.kubernetes_dashboard_chart_linting_enabled

  ingress_enabled = true
  ingress_class_name = local.kubernetes_dashboard_ingress_class_name
  ingress_annotations = local.kubernetes_dashboard_ingress_annotations
  ingress_host_address = local.kubernetes_dashboard_ingress_host_address
}
