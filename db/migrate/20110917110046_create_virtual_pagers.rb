class CreateVirtualPagers < ActiveRecord::Migration
  def change
    create_table :virtual_pagers do |t|
      t.string :name
      t.integer :min_active
      t.integer :max_active
      t.boolean :send_alerts
      t.boolean :log_messages
      t.boolean :active

      t.timestamps
    end
  end
end
