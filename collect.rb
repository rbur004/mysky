#!/usr/bin/env ruby
require_relative 'sky_commands.rb'

sky_cli = SkyCommands.new
File.open("/tmp/channels","a") do |fd|
  uri = sky_cli.current_uri
  fd.puts "#{ARGV[0]}\t#{uri}"
  puts uri
end
