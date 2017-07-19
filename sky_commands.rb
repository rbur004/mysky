require 'nokogiri'
require "net/http"
require 'uri'
require 'json'
require_relative 'mysky_nz_channels.rb'

#Derived from an uPnP scan, which lead to these:
#    http://#{skyAddress}#{port}/description0.xml
#    http://#{skyAddress}#{port}/description2.xml
#Oddly, sometimes they show up on description3 & 4 instead
#
class SkyCommands
  #Set up the connection. The decoder key is the uuid from a uPnP scan.
  def initialize
    conf = JSON.parse(File.read("conf.json"))
    @skyAddress = conf['skyAddress']
    @port = conf['port']
    @decoder_key = conf['decoder_key']
    @channels = MySky_Channels.new
  end

  #Send a SOAP packet to the Sky decoder, an print the result to STDOUT
  def send_command(actionName:, serviceType:, argList:, controlURL:, quiet: false )
    soapBody =  "<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><u:#{actionName} xmlns:u=\"urn:schemas-nds-com:service:#{serviceType}\">#{argList}</u:#{actionName}></s:Body></s:Envelope>\0xd\0xa"
    
    soapHeaders =  { 'Host' => "#{@skyAddress}:#{@port}",
                'Content-Type' => 'text/xml', 
                'SOAPAction' => "\"urn:schemas-nds-com:service:#{serviceType}##{actionName}\""
              }

    res = Net::HTTP.new(@skyAddress, @port).start do |http|
        url = "/#{@decoder_key}#{controlURL}"
        response = http.post(url, soapBody, soapHeaders)
        if !quiet
          puts response.code.to_i
          puts response.body #if response.code.to_i == 200
        end
        return response
    end
  end

#http://#{skyAddress}#{port}/player_avt.xml
  #Doesn't seem to work for files, but does work for channels.
  #Play a recorded programme
  #  @param uri [String] Programme path, as retrieved by getMediaInfo.
  def setAVTransportURI(uri:, currentURIMetaData: '')
    if uri != nil
      send_command( actionName: "SetAVTransportURI", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><CurrentURI>#{uri}</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>", controlURL: "SkyPlay") 
    end
  end
  alias :play_recording :setAVTransportURI

  #Not implemented
  def SetNextAVTransportURI(uri:, nextURIMetaData: '')
    send_command( actionName: "SetNextAVTransportURI", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><NextURI>#{uri}</NextURI><NextURIMetaData>#{nextURIMetaData}</NextURIMetaData>", controlURL: "SkyPlay") 
  end

  #Use the channel hash to map channel names or numbers to the Sky code for that channel.
  #  @param name [String] the Sky name for the channel
  #  @param number [Numeric] the Sky channel number
  def channel(name: nil, number: nil, code: nil)
    channel_code = @channels.find_channel_by_name(name: name) if name != nil
    channel_code = @channels.find_channel_by_number(number: number) if number != nil
    channel_code = code if code != nil

    if channel_code != nil
      play_recording(uri: "xsi://#{channel_code}", currentURIMetaData: '')
    end
  end

  #Start playing what ever is on, after a pause, fast forward or reverse
  def play
    speed(rate: 1)
  end
  
  def rewind(rate:)
    speed(rate: -rate)
  end
  
  #Fast forward or reverse (and normal play)
  def speed(rate:)
   if [-30,-12,-6,-2,1,2,6,12,30,'1/2'].include?(rate)
     send_command( actionName: "Play", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><Speed>#{rate}</Speed>", controlURL: "SkyPlay")
   end
  end
  alias :ff :speed

  #Pause what ever is playing
  def pause
    send_command( actionName: "Pause", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  #Stops playing recorded item. Returns 500 if not playing
  def stop
    send_command( actionName: "Stop", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay") 
  end

  #Doesn't work
  #Convenient action to advance to the next track. This action is functionally equivalent to
  # Seek(TRACK_NR,CurrentTrackNr+1). This action does not ‘cycle’ back to the first track.
  def next
    send_command( actionName: "Next", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay") 
  end

  #Doesn't work
  #Convenient action to advance to the previous track. This action is functionally equivalent to
  #Seek(TRACK_NR,CurrentTrackNr-1) . This action does not ‘cycle’ back to the last track.  
  def previous
    send_command( actionName: "Previous", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay") 
  end

  #Doesn't work
  #Start seeking through the resource controlled by the specified instance - as fast as possible - 
  #to the specified target position. Unit value “TRACK_NR” indicates seeking to a particular track number. 
  #For tape-based media that do not support the notion of track (such as VCRs), Seek(“TRACK_NR”,”1”) is
  # equivalent to the common “FastReverse” VCR functionality. Special track number ‘0’ is used to indicate the
  # end of the media, hence, Seek(“TRACK_NR”,”0”) is equivalent to the common “FastForward” VCR functionality.
  # @param unit [String] TRACK_NR, ABS_TIME, REL_TIME, ABS_COUNT, REL_COUNT, CHANNEL_FREQ, TAPE-INDEX, FRAME
  # @param target [Numeric]
  def seek(unit:, target:)
    send_command( actionName: "Previous", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID><Unit>#{unit}</Unit><Target>#{target}</Target>', controlURL: "SkyPlay") 
  end

  #Record (Doesn't work)
  def record
    send_command( actionName: "Record", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay") 
  end
  
  #Not implemented
  def setPlayMode(newPlayMode:)
      send_command( actionName: "SetPlayMode", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><NewPlayMode>#{newPlayMode}<NewPlayMode>", controlURL: "SkyPlay") 
    end

  #Lists recognised actions
  def getTranportationActions
    send_command( actionName: "GetCurrentTransportActions", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay") 
  end 

  def getTransportInfo
    send_command( actionName: "GetTransportInfo", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  def getTransportSettings
    send_command( actionName: "GetTransportSettings", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  #Lists details of playing media (only the channel is valid data)
  def getMediaInfo(quiet: false)
    send_command( actionName: "GetMediaInfo", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay", quiet: quiet)
  end

  #Lists details of playing media (only the channel is valid data)
  def getMediaInfo_Ext(quiet: false)
    send_command( actionName: "GetMediaInfo_Ext", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay", quiet: quiet)
  end

  def current_uri(quiet: true)
    response = getMediaInfo(quiet: quiet)
    return nil if response == nil || response.code.to_i != 200
    xml_root = Nokogiri::XML(response.body)
    return xml_root.xpath('//CurrentURI').text.strip
  end

  def getPositionInfo
    send_command( actionName: "GetPositionInfo", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  def getDeviceCapabilities
    send_command( actionName: "GetDeviceCapabilities", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  def x_NDS_GetCACondition
    send_command( actionName: "X_NDS_GetCACondition", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  def x_NDS_SetUserPIN(pin:)
    send_command( actionName: "X_NDS_SetUserPIN", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><UserPIN>#{pin}</UserPIN>", controlURL: "SkyPlay")
  end

#http://#{skyAddress}#{port}/player_cm.xml
  def getProtocolInfo
    send_command(actionName: "GetProtocolInfo", serviceType: 'SkyCM:2', argList: '', controlURL: 'SkyCM')
  end

  def getCurrentConnectionIDs
    send_command(actionName: "GetCurrentConnectionIDs", serviceType: 'SkyCM:2', argList: '', controlURL: 'SkyCM')
  end

  def getCurrentConnectionInfo
    send_command(actionName: "GetCurrentConnectionInfo", serviceType: 'SkyCM:2', argList: '<ConnectionID>0</ConnectionID>', controlURL: 'SkyCM')
  end

#http://#{skyAddress}#{port}/player_rc.xml
  #Returns just a FactoryDefaults preset.
  def listPresets
    send_command(actionName: "ListPresets", serviceType: 'SkyRC:2', argList: '<InstanceID>0</InstanceID>', controlURL: 'SkyRC')
  end
  
  #Failed, with 701 error. "TRANSITION NOT AVAILABLE"
  def selectPreset(presetName:)
      send_command(actionName: "SelectPreset", serviceType: 'SkyRC:2', argList: '<InstanceID>0</InstanceID><PresetName>#{presetName}</PresetName>', controlURL: 'SkyRC')
  end
  
  #Not implemented
  def getVolume(channel: 'Master')
    send_command(actionName: "GetVolume", serviceType: 'SkyRC:2', argList: '<InstanceID>0</InstanceID><Channel>#{channel}<Channel>', controlURL: 'SkyRC')
  end

  #Not implemented
  def getMute(channel: 'Master')
    send_command(actionName: "GetMute", serviceType: 'SkyRC:2', argList: '<InstanceID>0</InstanceID><Channel>#{channel}<Channel>', controlURL: 'SkyRC')
  end
  
  #Not implemented
  def setMute(channel: 'Master', mute: 1)
    send_command(actionName: "_etMute", serviceType: 'SkyRC:2', argList: '<InstanceID>0</InstanceID><Channel>#{channel}<Channel><DesiredMute>#{mute}</DesiredMute>', controlURL: 'SkyRC')
  end
  
  
#http://#{skyAddress}#{port}/scm_srs.xml
#SkyBook all calls fail with 500
  def getBookSortCapabilities
    send_command(actionName: "GetSortCapabilities", serviceType: 'SkyBook:2', argList: '', controlURL: 'SkyBook')
  end

  def getPropertyList(dataTypeID: 0)
    send_command(actionName: "GetPropertyList", serviceType: 'SkyBook:2', argList: "<DataTypeID>#{dataTypeID}</DataTypeID>", controlURL: 'SkyBook')
  end

  def getAllowedValues(dataTypeID: 0, filter: '*')
    send_command(actionName: "GetAllowedValues", serviceType: 'SkyBook:2', argList: "<DataTypeID>#{dataTypeID}</DataTypeID><Filter>#{filter}</Filter>", controlURL: 'SkyBook')
  end

  def getStateUpdateID
    send_command(actionName: "GetStateUpdateID", serviceType: 'SkyBook:2', argList: '', controlURL: 'SkyBook')
  end

  def browseRecordSchedules(filter: '*', startingIndex: 0, requestedCount: 25, sortCriteria: '')
    send_command(actionName: "BrowseRecordSchedules", serviceType: 'SkyBook:2', argList: "<Filter>#{filter}</Filter><StartingIndex>#{startingIndex}</StartingIndex><RequestedCount>#{requestedCount}</RequestedCount><SortCriteria>#{sortCriteria}</SortCriteria>", controlURL: 'SkyBook')
  end

  def browseRecordTasks(filter: '*', startingIndex: 0, requestedCount: 25, sortCriteria: '')
    send_command(actionName: "BrowseRecordTasks", serviceType: 'SkyBook:2', argList: "<Filter>#{filter}</Filter><StartingIndex>#{startingIndex}</StartingIndex><RequestedCount>#{requestedCount}</RequestedCount><SortCriteria>#{sortCriteria}</SortCriteria>", controlURL: 'SkyBook')
  end

  def createRecordSchedule(elements:)
    send_command(actionName: "CreateRecordSchedule", serviceType: 'SkyBook:2', argList: "<Elements>#{elements}</Elements>", controlURL: 'SkyBook')
  end

  def deleteRecordSchedule(recordScheduleID:)
    send_command(actionName: "DeleteRecordSchedule", serviceType: 'SkyBook:2', argList: "<RecordScheduleID>#{recordScheduleID}</RecordScheduleID>", controlURL: 'SkyBook')
  end

  def resetRecordTask(recordScheduleID: 0)
    send_command(actionName: "ResetRecordTask", serviceType: 'SkyBook:2', argList: "<RecordScheduleID>#{recordScheduleID}</RecordScheduleID>", controlURL: 'SkyBook')
  end

  def getRecordSchedule(recordScheduleID: 0)
    send_command(actionName: "GetRecordSchedule", serviceType: 'SkyBook:2', argList: "<RecordScheduleID>#{recordScheduleID}</RecordScheduleID>", controlURL: 'SkyBook')
  end

  def getRecordTask(recordTaskID: 0, filter: '*')
    send_command(actionName: "GetRecordTask", serviceType: 'SkyBook:2', argList: "<RecordTaskID>#recordTaskID</RecordTaskID><Filter>#{filter}</Filter>", controlURL: 'SkyBook')
  end
  
  def enableRecordTask(recordTaskID: 0)
    send_command(actionName: "EnableRecordTask", serviceType: 'SkyBook:2', argList: "<RecordTaskID>#recordTaskID</RecordTaskID>", controlURL: 'SkyBook')
  end

  def disableRecordTask(recordTaskID: 0)
    send_command(actionName: "DisableRecordTask", serviceType: 'SkyBook:2', argList: "<RecordTaskID>#recordTaskID</RecordTaskID>", controlURL: 'SkyBook')
  end

  def x_NDS_ManageQueue(status: )
    send_command(actionName: "X_NDS_ManageQueue", serviceType: 'SkyBook:2', argList: "<Status>#{status}</Status>", controlURL: 'SkyBook')
  end

  def x_NDS_UnlinkRecordTask(recordTaskID: 0)
    send_command(actionName: "X_NDS_UnlinkRecordTask", serviceType: 'SkyBook:2', argList: "<RecordTaskID>#recordTaskID</RecordTaskID>", controlURL: 'SkyBook')
  end

#http://#{skyAddress}#{port}/scm_cds.xml
#SkyBrowse (None of these seem to work. Give 500 response, which indicates a server error)
  def getSystemUpdateID
    send_command(actionName: "GetSystemUpdateID", serviceType: 'SkyBrowse:2', argList: '', controlURL: 'SkyBrowse')
  end

  def getBrowseSortCapabilities
    send_command(actionName: "GetSortCapabilities", serviceType: 'SkyBrowse:2', argList: '', controlURL: 'SkyBrowse')
  end

  def getFeatureList
    send_command(actionName: "GetFeatureList", serviceType: 'SkyBrowse:2', argList: '', controlURL: 'SkyBrowse')
  end

  def getSearchCapabilities
    send_command(actionName: "GetSearchCapabilities", serviceType: 'SkyBrowse:2', argList: '', controlURL: 'SkyBrowse')
  end

  def browse(objectID: 0, filter: '*', startingIndex: 0, requestedCount: 1,  sortCriteria: '')
    send_command(actionName: "Browse", serviceType: 'SkyBrowse:2', argList: "<ObjectID>#{objectID}</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>#{filter}</Filter><RequestedCount>#{requestedCount}</RequestedCount><StartingIndex>#{startingIndex}</StartingIndex><SortCriteria>#{sortCriteria}</SortCriteria>", controlURL: 'SkyBrowse')
  end

  def search(containerID: 0, searchCriteria: '', filter: '*',  startingIndex: 0, requestedCount: 25, sortCriteria: '')
    send_command(actionName: "Search", serviceType: 'SkyBrowse:2', argList: "<ContainerID>#{containerID}</ContainerID><SearchCriteria></SearchCriteria><Filter>#{filter}</Filter><StartingIndex>#{startingIndex}</StartingIndex><RequestedCount>#{requestedCount}</RequestedCount><SortCriteria>#{sortCriteria}</SortCriteria>", controlURL: 'SkyBrowse')
  end

  def destroyObject(objectID: )
    send_command(actionName: "DestroyObject", serviceType: 'SkyBrowse:2', argList: "<ObjectID>#{objectID}</ObjectID>", controlURL: 'SkyBrowse')
  end

  def updateObject(objectID:, currentTagValue:, newTagValue:)
    send_command(actionName: "UpdateObject", serviceType: 'SkyBrowse:2', argList: "<ObjectID>#{objectID}</ObjectID><CurrentTagValue>#{currentTagValue}<CurrentTagValue><NewTagValue>#{newTagValue}<NewTagValue>", controlURL: 'SkyBrowse')
  end

  def x_NDS_GetUpdateData(containerID:, reqUpdateID:, startingIndex: 0, requestedCount: 25)
    send_command(actionName: "X_NDS_GetUpdateData", serviceType: 'SkyBrowse:2', argList: "<ContainerID>#{containerID}</ContainerID><ReqUpdateID>#{reqUpdateID}<ReqUpdateID><StartingIndex>#{startingIndex}</StartingIndex><RequestedCount>#{requestedCount}</RequestedCount>", controlURL: 'SkyBrowse')
  end

  def x_NDS_UndeleteObject(objectID:, currentTagValue:, newTagValue:)
    send_command(actionName: "X_NDS_UndeleteObject", serviceType: 'SkyBrowse:2', argList: "<ObjectID>#{objectID}</ObjectID>", controlURL: 'SkyBrowse')
  end

  def x_NDS_DestroyObjectsMatchingCriteria(containerID: , searchCriteria: '')
    send_command(actionName: "X_NDS_DestroyObjectsMatchingCriteria", serviceType: 'SkyBrowse:2', argList: "<ContainerID>#{containerID}</ContainerID><SearchCriteria></SearchCriteria>", controlURL: 'SkyBrowse')
  end
end
