#!/usr/bin/env ruby
require_relative '../rlib/sky_commands.rb'

sky_cli = SkyCommands.new
puts "changing channel to #{ARGV[0]}"
if ARGV[0] =~ /^[0-9]+$/
  sky_cli.channel(number: ARGV[0].to_i)
else
  sky_cli.channel(name: ARGV[0])
end