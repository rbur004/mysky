# mysky

After a network scan, I found my mySky box has a number of ports open. One showed up in a uPnP scan too, so I followed the links in the uPnP output, and got a long list of SOAP XML commands that the sky box said it would respond to. These turn out to be standard AVTransport commands (google AVTransport Service Template).

Many of the commands don't seem to work, giving an HTML 500 error (server error). I might not be calling them correctly. I did get the fallowing to work:

* getTranportationActions shows only these are valid Play,Stop,Pause, with speeds =-30,-12,-6,-2,1/2,2,6,12,30
* SetAVTransportURI (Goes to a channel, but trying to play recorded content gives an HTML 500 error)
* play | rewind | ff (all just calling Play, with a speed)
* pause
* stop (Stops playing recorded programmes)
* getMediaInfo (Useful to build a list of channel codes)
* getTransportInfo (Current state and speed)

The rest either aren't that useful, or fail. Lots of goodies in there, if I could figure out how to make them work.

## conf.json
The configuration file defines the Sky box IP address, port (49153), and the boxes UUID code (which gets used in URLs). See example.conf.json

## upnp_probe.rb
Run this to discover your sky boxes IP address and UUID. My box has a fixed IP address, so I only need to run this once. If yours is dynamic, then this step may need to be done more often.

## mysky_nz_channels.rb
Is a list of channel names and numbers, and their Sky code (used in SetAVTransportURI). These were obtained by manually changing channel, and running getMediaInfo to get the code from the <CurrentURI>xsi://69</CurrentURI> line (Code here is '69', for channel 7, BBC TV). I didn't get every channel's code, running out of enthusiasm ;)

Class MySky_Channels has find_channel_by_name(name:) and find_channel_by_number(number:) to return the Sky code.

## Running

This is in the test phase, being done just to explore the Sky box SOAP API. I run 'test.rb', manually editing it each time. 

