require 'net/http'
require 'rexml/document'
include REXML

class VirtualPager < ActiveRecord::Base
  has_many :pagers
  has_many :page_logs
  validates_uniqueness_of :name, :short_code
  validates_presence_of :name, :short_code
  
  def send_page(msg,pager_list=nil) 
    # don't send a request if there is no point!
    # this line is preventing notifications of people 
    # being the last signed off pager
    # return false if self.number_of_pagers_signed_on < 1
	
  	# are we handed a list of pagers to send to? If so, use
  	# that list, if not, get the list of all pagers currently
  	# signed onto virtual pager
  	if pager_list
  		pager_numbers = pager_list
  	else
  		pager_numbers = self.all_pager_numbers
  	end

    # variable to store if the pager successfully was sent to at least 1 person
    succeeded = 0
    
    begin
      pager_numbers.each do |pn|
          # American Messaging WCTP URL
          target_url = 'http://wctp.amsmsg.net/wctp'
          url = URI.parse(target_url)
          request = Net::HTTP::Post.new(url.path)
    
          # generate XMl request
          xml_request = VirtualPager.create_xml_single(msg,pn)
          request.body = xml_request
    
          # Multi-thread pages, improves page repsonsiveness to large blasts
          # send request
          if PROXY['use_proxy']
          	response = Net::HTTP::Proxy(PROXY['proxy_url'], PROXY['proxy_port'], PROXY['proxy_username'], PROXY['proxy_password']).start(url.host, url.port) {|http| http.request(request)}
          else
          	response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
          end
    
          # log the message
        
          doc = Document.new response.body
          if doc.root.elements["wctp-Confirmation"].elements["wctp-Success"]
            status_code = 200 
            status_message = "Message accepted by wctp.amsmsg.net"
            succeeded += 1
          else
            status_code = doc.root.elements["wctp-Confirmation"].elements["wctp-Failure"].attributes["errorCode"]
            status_message = doc.root.elements["wctp-Confirmation"].elements["wctp-Failure"].attributes["errorText"]
          end
		
      		if self.log_messages
      		  log_message = msg
      		else
      		  log_message = "xxx (logging disabled) xxx"
      		end
    		
          self.page_logs.create(:pager_number => pn, :message => log_message, :status => status_code, :status_message => status_message)
        
      end
    rescue
      return false
    end
    
    if succeeded < 1
      return false
    else
      return succeeded
    end
  end
  
  def self.create_xml_single(msg,pager)
    doc = Document.new '<!DOCTYPE wctp-Operation 
         SYSTEM "http://wctp.myairmail.com/wctp-dtd-v1r1.dtd">'
    wctp_operation = doc.add_element 'wctp-Operation', {"wctpVersion" => "wctp-dtd-v1r1"}
    wctp_submitrequest = wctp_operation.add_element 'wctp-SubmitRequest'
    wctp_submitheader = wctp_submitrequest.add_element 'wctp-SubmitHeader', {"submitTimeStamp" => Time.now.strftime("%Y-%m-%dT%H:%M:%S")}
    wctp_submitheader.add_element 'wctp-Originator', {"senderID" => "ovinternalmed", "securityCode"=>"ovimsylmar"}
    wctp_submitheader.add_element 'wctp-MessageControl', {"messageID"=>Time.now.strftime("%s")}
    wctp_submitheader.add_element 'wctp-Recipient', {"recipientID"=>pager}
    wctp_payload = wctp_submitrequest.add_element 'wctp-Payload'
    wctp_alphanumeric = wctp_payload.add_element 'wctp-Alphanumeric'
    wctp_alphanumeric.text = msg
    doc << XMLDecl.new("1.0","UTF-8")

    return doc.to_s
  end
  
  def add_pager(pager_num)
    # test pager_num string to see if valid number
    if pager_num.delete("^0-9").size == 10
      pg_i = pager_num.delete("^0-9").to_i
      return nil if self.is_pager_signed_on?(pg_i)
      pager = self.pagers.create(:pager_number => pg_i)
	  
  	  # Send notification to the user that they are signed on
		  self.send_page("You are now covering: #{self.name}", [pager.pager_number]) if pager
		  return true
    else
      return nil
    end
  end
  
  def is_pager_signed_on?(pager_number)
    # verify pager number is type string for postgres, and search for it
    if self.pagers.find_by_pager_number(pager_number.to_s)
      return true
    else
      return false
    end
  end
  
  def is_code_level?
    return self.code_level
  end
  
  def number_of_pagers_signed_on
    return self.pagers.size
  end
  
  def remove_pager(pager_num)
  	return false unless is_pager_signed_on?(pager_num)
    if self.pagers.find_by_pager_number(pager_num).destroy
  		self.send_page("You have signed off of: #{self.name}", [pager_num])
  		return true
  	else
  		return false
  	end
  end
  
  def all_pager_numbers
    return self.pagers.collect{|x| x.pager_number}
  end
  
  def self.code_pagers
    return VirtualPager.find_all_by_code_level(true)
  end
  
  def self.pagers
    return VirtualPager.find_all_by_code_level(false)
  end
  
  
end
