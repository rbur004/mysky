#!/usr/bin/env ruby
require '../rlib/simple_upnp'

include_location_details = true
devices = SimpleUpnp::Discovery.search()
devices.each do |device|
  puts 'Device Found: '
  puts device.to_json(include_location_details)
  puts ''
end
