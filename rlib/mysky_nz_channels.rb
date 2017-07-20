#Retrieved with getMediaInfo, after manually changing to each channel.
#Hence, haven't captured all channels.
class MySky_Channels  
  def initialize
    @channel = {
      'preview' => {:channel => 0, :code => '132'},
      'TVNZ 1 HD' => {:channel => 1, :code => '322'},
      'TVNZ 2 HD' => {:channel => 2, :code => '324'},
      'Three HD' => {:channel => 3, :code => '323'},
      'Prime HD' => {:channel => 4, :code => '40D'},
      'the Box' => {:channel => 5, :code => 'C9'},
      'Vibe' => {:channel => 6, :code => '68'},
      'BBC UKTV' => {:channel => 7, :code => '69'},
      'Jones!' => {:channel => 8, :code => 'CB'},
      'Jones too' => {:channel => 208, :code => 'D6'},
      'Sky Box Sets' => {:channel => 9, :code => '522'},
      'SoHo' => {:channel => 10, :code => '1F6'},
      'Comedy Central' => {:channel => 11, :code => '450'},
      'Bravo' => {:channel => 12, :code => '83F'},
      'VICELAND' => {:channel => 13, :code => '518'},
      'E!' => {:channel => 14, :code => 'CF'},
      'MTV' => {:channel => 15, :code => '44F'},
      'TLC' => {:channel => 16, :code => 'CE'},
      'Living Channel' => {:channel => 17, :code => '192'},
      'FOOD TV' => {:channel => 18, :code => '198'},
      'Maori TV' => {:channel => 19, :code => '899'},
      'SKY ARTS' => {:channel => 20, :code => '579'},
      'HGTV' => {:channel => 21, :code => '83B'},
      'MTV Music' => {:channel => 22, :code => '57A'},
      'TVNZ Duke' => {:channel => 23, :code => '8A3'},
      'Choice TV' => {:channel => 24, :code => '835'},
      'Shopping Channel' => {:channel => 25, :code => '3F2'},
      'TVSN Shopping' => {:channel => 27, :code => '3F4'},
      'Preview' => {:channel => 28, :code => '140'},
      'SM Premiere' => {:channel => 31, :code => '12D'},
      'SM Extra' => {:channel => 30, :code => '1F5'},
      'SM Action' => {:channel => 32, :code => '25E'},
      'SM Greats' => {:channel => 33, :code => 'D0'},
      'SM Classics' => {:channel => 34, :code => '25A'},
      'SM Family' => {:channel => 36, :code => '206'},
      'SM Disney' => {:channel => 37, :code => '266'},
      'TCM' => {:channel => 38, :code => '519'},
      'Rialto' => {:channel => 39, :code => '25B'},
      'Sky Box Office 1' => {:channel => 40, :code => '4B1'},
      'Sky Box Office 2' => {:channel => 41, :code => '4B2'},
      'Sky Box Office 3' => {:channel => 42, :code => '4B3'},
      'Sky Box Office 4' => {:channel => 43, :code => '4B4'},
      #'Sport Mosaic' => {:channel => 50, :code => '298'}, #Get stuck here, and need remote to exit
      'SKY Sport 1' => {:channel => 51, :code => '191'},
      'Sky Sport 2' => {:channel => 52, :code => '65'},
      'Sky Sport 3' => {:channel => 53, :code => 'CA'},
      'Sky Sport 4' => {:channel => 54, :code => '197'},
      'Sport Pop-up 1' => {:channel => 55, :code => 'D3'},
      'Sport Pop-up 2' => {:channel => 56, :code => '51F'},
      'Sport Pop-up 3' => {:channel => 57, :code => '4BB'},
      'ESPN' => {:channel => 60, :code => '1F9'},
      'ESPN2' => {:channel => 61, :code => '4BA'},
      'TAB Trackside1' => {:channel => 62, :code => '581'},
      'TAB Trackside2' => {:channel => 63, :code => '259'},
      'Rugby Channel' => {:channel => 64, :code => '66'},
      'SKY ARENA' => {:channel => 65, :code => '1FA'},
      'beIN SPORTS 1' => {:channel => 266, :code => '457'},
      'beIN SPORTS 2' => {:channel => 267, :code => '458'},
      'beIN Pop-up 1' => {:channel => 268, :code => '4BF'},
      'beIN Pop-up 2' => {:channel => 269, :code => '520'},
      'Discovery' => {:channel => 70, :code => 'CC'},
      'CI' => {:channel => 71, :code => '57B'},
      'Nat GEO' => {:channel => 72, :code => '6B'},
      'History' => {:channel => 73, :code => '193'},
      'BBC Knowledge' => {:channel => 74, :code => '57E'},
      'Discovery Turbo' => {:channel => 75, :code => '273'},
      'Animal Planet' => {:channel => 76, :code => '453'},
      'GARAGE' => {:channel => 77, :code => '3F1'},
      'Country TV' => {:channel => 81, :code => '452'},
      'Te Reo' => {:channel => 82, :code => '839'},
      'FACE TV' => {:channel => 83, :code => '3EB'},
      'SKY News' => {:channel => 85, :code => '12F'},
      'Parliament TV' => {:channel => 86, :code => '836'},
      'CNN' => {:channel => 87, :code => '451'},
      'Fox News' => {:channel => 88, :code => '580'},
      'BBC World News' => {:channel => 89, :code => '6D'},
      'Al Jazeera' => {:channel => 90, :code => '3EA'},
      'CNBC' => {:channel => 91, :code => '3EE'},
      'RT' => {:channel => 92, :code => '51A'},
      'Disney Channel' => {:channel => 100, :code => '454'},
      'Nickelodeon' => {:channel => 101, :code => '57F'},
      'Cartoon Network' => {:channel => 102, :code => '12E'},
      'Disney XD' => {:channel => 103, :code => '58A'},
      'Nick Jr.' => {:channel => 104, :code => '57C'},
      'Disney Junior' => {:channel => 105, :code => '199'},
      'SM Disney 2' => {:channel => 107, :code => '26D'},
      'The Edge TV' => {:channel => 114, :code => '13B'},
      'Star Plus Hindi' => {:channel => 150, :code => '51B'},
      'Colors' => {:channel => 151, :code => '4B7'},
      'Star Gold' => {:channel => 152, :code => '515'},
      'SCC' => {:channel => 155, :code => 'CD'},
      'SCM' => {:channel => 156, :code => '516'},
      'TFC' => {:channel => 160, :code => '517'},
      #'Upgrade App' => {:channel => 200, :code => '29B'}, #Get stuck here, and need remote to exit
      'Shine TV' => {:channel => 201, :code => '83A'},
      'Daystar' => {:channel => 202, :code => '3EC'},
      'SonLife' => {:channel => 203, :code => '1FF'},
      'Hope Channel' => {:channel => 204, :code => '841'},
      'Firstlight' => {:channel => 206, :code => '83C'},
      'CGTN' => {:channel => 310, :code => '6A'},
      'Real Good Life Radio' => {:channel => 311, :code => '1AB'},
      'New Supremo Radio' => {:channel => 312, :code => '1AC'},
      'FM 104.a Radio2' => {:channel => 313, :code => '1AE'},
      'Playboy	' => {:channel => 140, :code => '51D'},
      'Desire TV' => {:channel => 141, :code => '4B8'},
      'Brazzers TV' => {:channel => 142, :code => '4B9'},
      'NZ Chart Radio' => {:channel => 400, :code => '7F'},
      'Pop Radio' => {:channel => 401, :code => '80'},
      'Smooth Radio' => {:channel => 402, :code => '81'},
      'Grooves Radio' => {:channel => 403, :code => '26F'},
      'Jazz Radio' => {:channel => 404, :code => 'E1'},
      'House Radio' => {:channel => 405, :code => 'E2'},
      '50s & 60s Radio' => {:channel => 406, :code => 'E3'},
      'Party Radio' => {:channel => 407, :code => 'E4'},
      'Rock Radio' => {:channel => 408, :code => 'E5'},
      'Country Radio' => {:channel => 409, :code => 'E6'},
      'Classical Radio' => {:channel => 410, :code => '145'},
      'Kids Radio' => {:channel => 411, :code => '146'},
      'Blues Radio' => {:channel => 412, :code => '1AD'},
      'Summer of Love Radio' => {:channel => 413, :code => '147'},
      'RNZ National Radio' => {:channel => 421, :code => '141'},
      'RNZ Concert Radio' => {:channel => 422, :code => '142'},
      'Tahu FM Radio' => {:channel => 423, :code => '149'},
      'TVNZ 1 +1' => {:channel =>  501, :code => '89D'},
      'TVNZ 2 +1' => {:channel => 502, :code => '8A2'},
      'ThreePlus1' => {:channel => 503, :code => '83E'},
      'Bravo PLUS1' => {:channel => 512, :code => '13A'},
      'Prime PLUS1' => {:channel => 514, :code => '138'},
      'Preview 2' => {:channel => 319, :code => '13F'},
      'LNB Test' => {:channel => 999, :code => '22C5'}
    }
  end
  
  #Is this a valid code
  def isvalid?(code:)
    @channel.each { |k,v|  return true if code == v[:code] }
    return false
  end
  
  #Search the @channel hosh for the chonnel name given
  #  @param name [String] the Sky channel name
  #  @return [String] Sky channel code
  def find_channel_by_name(name:)
    return @channel[name][:code] if @channel[name] != nil
    return nil
  end
  
  #Search the @channel hosh for the chonnel number given
  #  @param number [Numeric] the Sky channel number
  #  @return [String] Sky channel code
  def find_channel_by_number(number:)
   @channel.each { |k,v|  return v[:code] if number == v[:channel] }
   return nil
  end
  
  #Search using partial name. Will find the first match, which may not be what you want :(
  #  @param name [String] the Sky channel name
  #  @return [String] Sky channel code
  def match_channel(name:)
    @channel.each { |k,v|  return v[:code] if k.downcase =~ /#{name.downcase}/ }
    return nil
  end
  
  def up(current_code:)
    return current_code if current_code == nil || current_code =~ /^file:/
    next_one = false
    @channel.each do |k,v|
      if current_code == v[:code]
        next_one = true
      elsif next_one
        return v[:code]
      end
    end  
    return @channel.values[0][:code] #Looped
  end
  
  def down(current_code:)
    return current_code if current_code == nil || current_code =~ /^file:/
    this_one = @channel.values[-1][:code]
    @channel.each do |k,v|
      return this_one if current_code == v[:code]
      this_one = v[:code]
    end
  end
end

