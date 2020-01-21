class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.integer :object_id
      t.string :object_type
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :notifications, :sender_id
    add_index :notifications, :receiver_id
  end
end
