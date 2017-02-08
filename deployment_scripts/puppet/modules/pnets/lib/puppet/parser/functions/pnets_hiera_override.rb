require 'yaml'

module Puppet::Parser::Functions
  newfunction(:pnets_hiera_override, :type => :rvalue, :arity => 2) do |args|
    mappings, segmentation = args

    override = {}
    pnets_hash = {}
    vlan_nets = []
    mappings.each do |netmap|
      netmap.gsub!(/\s+/, '')
      arr = netmap.split(',')
      if arr.size < 2
        fail("Not valid network mapping: #{netmap}")
      end
      vlan_range = (arr.size > 2 ? arr[2] : nil)
      if segmentation == 'tun' and vlan_range
        vlan_nets << "#{arr[0]}:#{vlan_range}"
      end
      pnets_hash.merge!({arr[0]=>{'bridge'=>arr[1], 'vlan_range'=> vlan_range}})
    end
    if not vlan_nets.empty?
      override['configuration'] = {
        'neutron_plugin_ml2' => {
          'ml2_type_vlan/network_vlan_ranges' => {
            'value' => vlan_nets.join(',')
          }
        }
      }
    end

    override['neutron_config'] = {
      'L2' => {'phys_nets' => pnets_hash}
    }

    override.to_yaml
  end
end
