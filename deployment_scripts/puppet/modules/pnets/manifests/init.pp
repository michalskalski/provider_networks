class pnets {
  $override_file = '/etc/hiera/plugins/provider_networks.yaml'
  $conf = hiera('provider_networks')
  $neutron_config = hiera_hash('neutron_config')
  $segmentation_type = try_get_value($neutron_config, 'L2/segmentation_type')
  $pnets = pnets_hiera_override(
    $conf['network_list'],
    $segmentation_type
  )
  file { $override_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => $pnets,
  }
}
