data "cloudflare_zone" "external_domain" {
  count = local.create_dns_records ? 1 : 0
  depends_on = [
    data.kubernetes_config_map.network_context
  ]
  filter = {
    name = local.external_domain
  }
}

resource "cloudflare_dns_record" "kubernetes_dashboard" {
  count = local.create_dns_records && module.kubernetes_dashboard[0].ingress_enabled ? 1 : 0
  depends_on = [
    data.kubernetes_config_map.network_context,
    data.cloudflare_zone.external_domain,
    module.kubernetes_dashboard
  ]
  zone_id = data.cloudflare_zone.external_domain[0].id
  name = module.kubernetes_dashboard[0].ingress_address
  ttl = local.dns_ttl_seconds
  proxied = local.dns_records_proxy_enabled
  type = "A"
  content = local.external_ingress_ip
  comment = local.dns_records_default_comment
}
