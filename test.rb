#!/usr/bin/env ruby
require_relative 'sky_commands.rb'

sky_cli = SkyCommands.new

#sky_cli.play_recording(name: "/pvr/29012F89") #Fails
#sky_cli.browseRecordTasks #Fails
#sky_cli.channel(number: 7) #Sky Movies
sky_cli.getMediaInfo
exit 0

sky_cli.speed(-30)
sleep 3
sky_cli.speed(30)
sleep 5

sky_cli.getMediaInfo
sleep 3
sky_cli.channel(number: 30) #Sky Movies
sky_cli.getMediaInfo
sleep 3
sky_cli.channel(name: 'Prime') #Channel 4
sky_cli.getMediaInfo



#sky_cli.play_recording(name: "http://10.2.2.196:80/mp4/new/Victoria.mp4") #Fails with 500

#
#sky_cli.play
#sky_cli.stop

#sky_cli.browseRecordTasks(filter:'', startingIndex:0, requestedCount:10, sortCriteria:'')
#sky_cli.getPositionInfo
#sky_cli.getMediaInfo_Ext
#sky_cli.getMediaInfo
#sky_cli.play_recording(name: "file://pvr/29012F89")
#sky_cli.play_recording(name: "file://pvr/29013D47")
#sky_cli.getMediaInfo
#sky_cli.play_recording(name: "/pvr/29013D47")
#sky_cli.browseRecordTasks
#sky_cli.channel(number: 30)
#sky_cli.getSystemUpdateID
#sky_cli.getFeatureList
#sky_cli.getBrowseSortCapabilities
#sky_cli.getBookSortCapabilities
