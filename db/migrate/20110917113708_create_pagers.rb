class CreatePagers < ActiveRecord::Migration
  def change
    create_table :pagers do |t|
      t.text :pager_number
      t.integer :virtual_pager_id

      t.timestamps
    end
  end
end
