class AddCodeLevelToVirtualPagers < ActiveRecord::Migration
  def up
      add_column :virtual_pagers, :code_level, :boolean
  end
  
  def down
      remove_column :virtual_pagers, :code_level
  end
  
end
