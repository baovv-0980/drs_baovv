class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.integer :type, default: 0
      t.datetime :time
      t.text :reason
      t.integer :status, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :requests, [:user_id, :created_at]
  end
end
