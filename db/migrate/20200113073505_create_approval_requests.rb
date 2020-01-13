class CreateApprovalRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :approval_requests do |t|
      t.integer :status, default: 0
      t.integer :request_id
      t.references :division, foreign_key: true

      t.timestamps
    end
  end
end
