class PageLog < ActiveRecord::Migration
  def up
    create_table :page_logs do |t|
      t.text :pager_number
      t.integer :virtual_pager_id
      t.text :message
      t.integer :status
      t.text :status_message
      t.timestamps
    end
  end

  def down
    drop_table :page_logs
  end
end
