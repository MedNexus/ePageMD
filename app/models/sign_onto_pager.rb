class SignOntoPager
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :virtual_pager_id, :pager_number, :sign_on_off
  
  validates_presence_of :virtual_pager_id, :pager_number, :sign_on_off
  
  def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
  end
  
  def persisted?
    false
  end
  
  # Add / Remove pager to virtual pager
  def process
    if self.valid?
      vp = VirtualPager.find_by_id(self.virtual_pager_id)
      if self.sign_on_off == 'ON'
        return true if vp.add_pager(self.pager_number)
        self.errors.add :sign_on_off, ": Cannot sign you onto pager, are you already signed on?"
      elsif
        self.sign_on_off == 'OFF'
        return true if vp.remove_pager(self.pager_number)
        self.errors.add :sign_on_off, ": Cannot sign you off pager, maybe you are not signed on?"
      else
        return false
      end
      return false
    end
  end
  
end