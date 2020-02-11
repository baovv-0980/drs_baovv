class UserGroup < ApplicationRecord
  PARAMS = %i(user_id group_id role).freeze
  enum role: {member: 0, leader: 1}
  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :user_id, scope: :group_id
end
