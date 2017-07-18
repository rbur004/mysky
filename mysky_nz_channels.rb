#Retrieved with getMediaInfo, after manually changing to each channel.
#Hence, haven't captured all channels.
class MySky_Channels  
  def initialize
    @channel = {
      'TV1' => {:channel => 1, :code => '322'},
      'TV2' => {:channel => 2, :code => '324'},
      'TV3' => {:channel => 3, :code => '323'},
      'Prime' => {:channel => 4, :code => '40D'},
      'the Box' => {:channel => 5, :code => 'C9'},
      'Vibe' => {:channel => 6, :code => '68'},
      'BBC TV' => {:channel => 7, :code => '69'},
      'Jones' => {:channel => 8, :code => 'CB'},
      'Jones Too' => {:channel => 208, :code => 'D6'},
      'Box Sets' => {:channel => 9, :code => '522'},
      'Soho' => {:channel => 10, :code => '1F6'},
      'Comedy Central' => {:channel => 11, :code => '450'},
      'Bravo' => {:channel => 12, :code => '83F'},
      'Viceland' => {:channel => 13, :code => '518'},
      'E!' => {:channel => 14, :code => 'CF'},
      'MTV' => {:channel => 15, :code => '44F'},
      'TLC' => {:channel => 16, :code => 'CE'},
      'Living Channel' => {:channel => 17, :code => '192'},
      'Food Channel' => {:channel => 18, :code => '198'},
      'Maori Channel' => {:channel => 19, :code => '899'},
      'Sky Arts' => {:channel => 20, :code => '579'},
      'HGTV' => {:channel => 21, :code => '83B'},
      'MTV Music' => {:channel => 22, :code => '57A'},
      'TVNZ Duke' => {:channel => 23, :code => '8A3'},
      'Choice TV' => {:channel => 24, :code => '835'},
      'SM Premiere' => {:channel => 30, :code => '12D'},
      'SM Extra' => {:channel => 31, :code => '1F5'},
      'SM Action' => {:channel => 32, :code => '25E'},
      'SM Greats' => {:channel => 33, :code => 'D0'},
      'SM Classics' => {:channel => 34, :code => '25A'},
      'SM Family' => {:channel => 36, :code => '206'},
      'SM Disney' => {:channel => 37, :code => '266'},
      'TCM' => {:channel => 38, :code => '519'},
      'Rialto' => {:channel => 39, :code => '25B'},
      'Discovery' => {:channel => 70, :code => 'CC'},
      'CI' => {:channel => 71, :code => '57B'},
      'NAT GEO' => {:channel => 72, :code => '6B'},
      'History' => {:channel => 73, :code => '193'},
      'BBC Knowledge' => {:channel => 74, :code => '57E'},
      'Discovery Turbo' => {:channel => 75, :code => '273'},
      'Animal Planet' => {:channel => 76, :code => '453'},
      'Garage' => {:channel => 77, :code => '3F1'},
      'Face TV' => {:channel => 83, :code => '3EB'},
      'Sky News' => {:channel => 85, :code => '12F'},
      'CNN' => {:channel => 87, :code => '451'},
      'BBC News' => {:channel => 89, :code => '6D'},
      'Al Jazeera' => {:channel => 90, :code => '3EA'},
      'CNBC' => {:channel => 91, :code => '3EE'},
      'RT' => {:channel => 92, :code => '51A'},
      'Disney' => {:channel => 100, :code => '454'},
      'Nickelodeon' => {:channel => 101, :code => '57F'},
      'Cartoon' => {:channel => 102, :code => '12E'},
      'Disney XD' => {:channel => 103, :code => '58A'},
      'Team Umizoomi' => {:channel => 104, :code => '57C'},
      'Disney Junior' => {:channel => 105, :code => '199'},
      'SM Disney2' => {:channel => 107, :code => '26D'},
      'The Edge TV' => {:channel => 114, :code => '13B'},
      'RNZ National' => {:channel => 421, :code => '141'},
      'RNZ Concert' => {:channel => 422, :code => '142'},
      'TV1+1' => {:channel => 501, :code => '89D'},
      'TV2+1' => {:channel => 502, :code => '8A2'},
      'TV3+1' => {:channel => 503, :code => '83E'},
      'Bravo+1' => {:channel => 512, :code => '13A'},
      'Prime+1' => {:channel => 514, :code => '138'}  
    }
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
  
  def up(current_code:)
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
    this_one = @channel.values[-1][:code]
    @channel.each do |k,v|
      return this_one if current_code == v[:code]
      this_one = v[:code]
    end
  end
end

