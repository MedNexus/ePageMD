class CodePage
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :virtual_pager_id, :location  
  
  validates_presence_of :virtual_pager_id, :location

  
  def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
  end
  
  # actually send the code notification
  def send_page
    begin
      vp = VirtualPager.find_by_id(self.virtual_pager_id)
      message = "#{vp.name}: #{self.location}"
      return vp.send_page(message)
    rescue
      return false
    end
  end
  
  def persisted?
    false
  end
  
end