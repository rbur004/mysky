#!/usr/bin/env ruby
require_relative '../rlib/sky_commands.rb'

sky_cli = SkyCommands.new

channels = MySky_Channels.new
(668..5000).each do |i|
  code = "%X" % i
  if channels.isvalid?(code: code) == false && code != '29B' #29B is a black hole.
    response = sky_cli.channel(code: code, quiet: true)
    if response.code.to_i == 200
      puts code
    end
  end
  sleep 2
end
#sky_cli.getMediaInfo
#puts
#sky_cli.getMediaInfo
#sky_cli.channel(code: "324")
#sky_cli.getMediaInfo

#puts
#sky_cli.channel(name: 'Rialto')

#sky_cli.getMediaInfo_Ext #No more useful data than getMediaInfo
#sky_cli.getTransportInfo
#sky_cli.getTransportSettings
#sky_cli.getPositionInfo
#sky_cli.listPresets #Only FactoryDefaults.
#sky_cli.getTranportationActions #Play,Stop,Pause
#sky_cli.channel(number: 7) #BBC TV
#sky_cli.channel(name: 'Prime') #Channel 4
#sky_cli.stop #No effect if on TV, but stops a running file playing and drops back to TV

#sky_cli.rewind(rate: 30)
#sleep 5
#sky_cli.ff(rate: 30)
#sleep 5
#sky_cli.play
#sky_cli.stop

#All these fail
#sky_cli.setMute #Fails. Unimplemented.
#sky_cli.setMute(mute: 0) #Fails. Unimplemented.
#sky_cli.selectPreset(presetName: "FactoryDefaults") #fails with 701 error
#sky_cli.selectPreset(presetName: "InstallationDefaults")  #fails with 701 error
#sky_cli.browseRecordTasks(filter:'', startingIndex:0, requestedCount:10, sortCriteria:'')
#sky_cli.play_recording(name: "file://pvr/29012F89") #Fails
#sky_cli.play_recording(uri: "http://10.2.2.196:80/mp4/new/Victoria.mp4") #Fails.
#sky_cli.browseRecordTasks
#sky_cli.getSystemUpdateID
#sky_cli.getFeatureList
#sky_cli.getBrowseSortCapabilities
#sky_cli.getBookSortCapabilities
