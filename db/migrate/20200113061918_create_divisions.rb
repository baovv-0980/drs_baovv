class CreateDivisions < ActiveRecord::Migration[6.0]
  def change
    create_table :divisions do |t|
      t.string :name
      t.integer :parent_id
      t.string :parent_path

      t.timestamps
    end
  end
end
