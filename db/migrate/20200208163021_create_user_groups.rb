class CreateUserGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :user_groups do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :role, default: 0

      t.timestamps
      add_index :user_groups, [:user, :group], unique: true
    end
  end
end
