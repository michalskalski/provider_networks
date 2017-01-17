require 'yaml'

module Puppet::Parser::Functions
  newfunction(:pnets_hiera_override, :arity => 2) do |args|
    filename, mappings = args

    pnets_hash = {}
    mappings.each do |netmap|
      netmap.gsub!(/\s+/, '')
      arr = netmap.split(',')
      if arr.size < 2
        fail("Not valid network mapping: #{netmap}")
      end
      vlan_range = (arr.size > 2 ? arr[2] : nil)
      pnets_hash.merge!({arr[0]=>{'bridge'=>arr[1], 'vlan_range'=> vlan_range}})
    end

    neutron_config = {
      'neutron_config' => {
        'L2' => {'phys_nets' => pnets_hash}
      }
    }

    # write to hiera override yaml file
    File.open(filename, 'w') { |file| file.write(neutron_config.to_yaml) }
  end
end
