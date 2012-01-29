class RoutinePage
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :virtual_pager_id, :message, :patient_id, :urgency
  
  validates_presence_of :virtual_pager_id, :message, :urgency

  
  def initialize(attributes = {})
      self.urgency = 3
      attributes.each do |name, value|
        send("#{name}=", value)
      end
  end
  
  # actually send the code notification
  def send_page
    begin
      vp = VirtualPager.find_by_id(self.virtual_pager_id)
      message = "#{self.urgency_as_symbol}, #{vp.short_code}, ##{self.patient_id}: #{self.message}"
      return vp.send_page(message)
    rescue
      return false
    end
  end
  
  def persisted?
    false
  end
  
  def urgency_as_symbol
    if self.urgency == "1"
      return "!!"
    elsif self.urgency == "2"
      return "!"
    elsif self.urgency == "3"
      return "R"
    elsif self.urgency == "4"
      return "FYI"
    else
      return "?"
    end
  end
  
end