#!/usr/bin/env ruby
require_relative 'sky_commands.rb'
  
sky_cli = SkyCommands.new
current_code = sky_cli.current_uri
if current_code != nil && current_code !~ /file:/
  current_code = current_code.split('/')[-1]
  new_code = MySky_Channels.new.up(current_code: current_code)
  sky_cli.channel(code: new_code)
end

