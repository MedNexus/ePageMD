require 'net/http'
require 'rexml/document'
include REXML

class VirtualPager < ActiveRecord::Base
  has_many :pagers
  
  def send_page(msg) 
    # don't send a request if there is no point!
    return false if self.number_of_pagers_signed_on < 1
    
    # American Messaging WCTP URL
    target_url = 'http://wctp.amsmsg.net/wctp'
    url = URI.parse(target_url)
    request = Net::HTTP::Post.new(url.path)
    
    # generate XMl request
    xml_request = VirtualPager.create_xml_single(msg,self.pagers.first.pager_number)
    request.body = xml_request
    
    # send request
    response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
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

    url = URI.parse('http://wctp.amsmsg.net/wctp')
    request = Net::HTTP::Post.new(url.path)
    return doc.to_s
    response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
  end
  
  def add_pager(pager_num)
    # test pager_num string to see if valid number
    if pager_num.delete("^0-9").size == 10
      pg_i = pager_num.delete("^0-9").to_i
      return nil if self.is_pager_signed_on?(pg_i)
      return self.pagers.create(:pager_number => pg_i)
    else
      return nil
    end
  end
  
  def is_pager_signed_on?(pager_number)
    if self.pagers.find_by_pager_number(pager_number)
      return true
    else
      return false
    end
  end
  
  def number_of_pagers_signed_on
    return self.pagers.size
  end
  
  def remove_pager(pager_num)
    return self.pagers.find_by_pager_number(pager_num).destroy
  end
  
end
