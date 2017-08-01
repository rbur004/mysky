#!/usr/bin/env ruby
require_relative '../rlib/sky_commands.rb'

sky_cli = SkyCommands.new

#Look for channels not in my channel list
channels = MySky_Channels.new
(0..0xFFFF).each do |i|
  code = "%X" % i
  if channels.isvalid?(code: code) == false && !channels.skip.include?(code) #these require remote 'cancel' to continue.
    response = sky_cli.channel(code: code, quiet: true)
    if response.code.to_i == 200
      puts code
    end
  end
end
