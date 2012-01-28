class SignOnoffMultiple
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :pager_number
  attr_accessor :virtual_pagers
  
  validates_presence_of :pager_number
  
  def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
  end
  
  def persisted?
    false
  end
  
  def list_signed_on
    return Pager.virtual_pagers_signed_on(self.pager_number)
  end
  
  def list_signed_off
    return Pager.virtual_pagers_signed_off(self.pager_number)    
  end
  
  def update
    # iterate through each virtual pager and update accordingly
    self.virtual_pagers.each do |id,val|
      if val == "1"
        VirtualPager.find_by_id(id).add_pager(self.pager_number)
      else
        VirtualPager.find_by_id(id).remove_pager(self.pager_number)
      end
    end
  end
  
end