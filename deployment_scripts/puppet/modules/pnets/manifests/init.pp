class pnets {
  $override_file = '/etc/hiera/plugins/provider_networks.yaml'
  $conf = hiera('provider_networks')
  pnets_hiera_override(
    $override_file,
    $conf['network_list']
  )
}
