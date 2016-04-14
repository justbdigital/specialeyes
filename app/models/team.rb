class Team < ActiveRecord::Base
  belongs_to :owner, class_name: Pro

  has_many :members, class_name: Pro, foreign_key: :member_of_id
end
