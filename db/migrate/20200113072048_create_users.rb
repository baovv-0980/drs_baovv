class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.text :skill
      t.date :birthday
      t.string :phone
      t.integer :staff_type, default: 0
      t.integer :workspace, default: 0
      t.integer :gender, default: 0
      t.integer :nationality, default: 0
      t.integer :position, default: 0
      t.integer :role, default: 0
      t.references :division, foreign_key: true
      t.timestamps
    end
  end
end
