class VirtualPager < ActiveRecord::Base
  has_many :pagers
  
  def send_page(msg)
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
