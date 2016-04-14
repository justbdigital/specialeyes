# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ActiveRecord::Base
  belongs_to :owner, class_name: Pro

  has_many :members, class_name: Pro, foreign_key: :member_of_id
end
