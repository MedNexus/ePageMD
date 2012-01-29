class AddPagerShortCode < ActiveRecord::Migration
  def up
    add_column :virtual_pagers, :short_code, :text
    VirtualPager.find(:all).each do |vp|
      vp.short_code = vp.name
      vp.save
    end
  end

  def down
    remove_column :virtual_pagers, :short_code
  end
end
