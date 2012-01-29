class AddPagerShortCode < ActiveRecord::Migration
  def up
    add_column :virtual_pagers, :short_code, :text
  end

  def down
    remove_column :virtual_pagers, :code_level
  end
end
