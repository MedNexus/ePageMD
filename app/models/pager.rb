class Pager < ActiveRecord::Base
  belongs_to :virtual_pager
  
  def self.virtual_pagers_signed_on(pager_num)
    return Pager.find_all_by_pager_number(pager_num).collect{|x| x.virtual_pager}
  end
  
  def self.virtual_pagers_signed_off(pager_num)
    @vp_all = VirtualPager.find(:all)
    @vp_on = Pager.virtual_pagers_signed_on(pager_num)
    return @vp_all.reject{ |i| i if @vp_on.include? i }
  end
  
  
end
