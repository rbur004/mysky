require "net/http"
require 'uri'
require 'json'
require_relative 'mysky_nz_channels.rb'

#Derived from an uPnP scan, which lead to these:
#    http://#{skyAddress}#{port}/description0.xml
#    http://#{skyAddress}#{port}/description2.xml
#Oddly, once they showed up on description3 & 4 instead
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
  def send_command(actionName:, serviceType:, argList:, controlURL: )
    soapBody = 	"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><u:#{actionName} xmlns:u=\"urn:schemas-nds-com:service:#{serviceType}\">#{argList}</u:#{actionName}></soap:Body></soap:Envelope>"
		
    soapHeaders =  { 'Host' => "#{@skyAddress}:#{@port}",
                'Content-Type' => 'text/xml', 
        				'SOAPAction' => "\"urn:schemas-nds-com:service:#{serviceType}##{actionName}\""
              }

    res = Net::HTTP.new(@skyAddress, @port).start do |http|

        url = "/#{@decoder_key}#{controlURL}"
        post = Net::HTTP::Post.new(url)
        post.body = soapBody
        response = http.post(url, post.body, soapHeaders)
        puts response.code.to_i
        puts response.body if response.code.to_i == 200
    
    end
  end

  #Use the channel hash to map channel names or numbers to the Sky code for that channel.
  #  @param name [String] the Sky name for the channel
  #  @param number [Numeric] the Sky channel number
  def channel(name: nil, number: nil)
    channel_code = @channels.find_channel_by_name(name: name) if name != nil
    channel_code = @channels.find_channel_by_number(number: number) if number != nil

    if channel_code != nil
      send_command( actionName: "SetAVTransportURI", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><CurrentURI>xsi://#{channel_code}</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>", controlURL: "SkyPlay") 
    end
  end

  #Doesn't seem to work.
  #Play a recorded programme
  #  @param name [String] Programme path, as retrieved by getMediaInfo.
  def play_recording(name:)
    if name != nil
      send_command( actionName: "SetAVTransportURI", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><CurrentURI>file://#{name}</CurrentURI><CurrentURIMetaData></CurrentURIMetaData>", controlURL: "SkyPlay") 
    end
  end

  #Start playing what ever is on, after a pause, fast forward or reverse
  def play
    speed(1)
  end

  #Fast forward or reverse (and normal play)
  def speed(value)
   if [-30,-12,-6,-2,1,2,6,12,30,'1/2'].include?(value)
     send_command( actionName: "Play", serviceType: "SkyPlay:2", argList: "<InstanceID>0</InstanceID><Speed>#{value}</Speed>", controlURL: "SkyPlay")
   end
  end

  #Pause what ever is playing
  def pause
    send_command( actionName: "Pause", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  #Stops playing recorded item. Returns 500 if not playing
  def stop
    send_command( actionName: "Stop", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay") 
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
  def getMediaInfo
    send_command( actionName: "GetMediaInfo", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
  end

  #Lists details of playing media (only the channel is valid data)
  def getMediaInfo_Ext
    send_command( actionName: "GetMediaInfo_Ext", serviceType: "SkyPlay:2", argList: '<InstanceID>0</InstanceID>', controlURL: "SkyPlay")
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

  #SkyCM
  def getProtocolInfo
    send_command(actionName: "GetProtocolInfo", serviceType: 'SkyCM:2', argList: '', controlURL: 'SkyCM')
  end

  def getCurrentConnectionIDs
    send_command(actionName: "GetCurrentConnectionIDs", serviceType: 'SkyCM:2', argList: '', controlURL: 'SkyCM')
  end

  def getCurrentConnectionInfo
    send_command(actionName: "GetCurrentConnectionInfo", serviceType: 'SkyCM:2', argList: '<ConnectionID>0</ConnectionID>', controlURL: 'SkyCM')
  end

  #SkyRC
  def listPresets
    send_command(actionName: "ListPresets", serviceType: 'SkyRC:2', argList: '<InstanceID>0</InstanceID>', controlURL: 'SkyRC')
  end

  #SkyBook all calls fail with 500
  def getBookSortCapabilities
    send_command(actionName: "GetSortCapabilities", serviceType: 'SkyBook:2', argList: '', controlURL: 'SkyBook')
  end

  def getPropertyList(dataTypeID: 0)
    send_command(actionName: "GetPropertyList", serviceType: 'SkyBook:2', argList: "<DataTypeID>#{dataTypeID}</DataTypeID>", controlURL: 'SkyBook')
  end

  def getAllowedValues(dataTypeID: 0, filter: '')
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
