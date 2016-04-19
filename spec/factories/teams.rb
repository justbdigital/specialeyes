# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :team do
    association :owner, factory: :pro, strategy: :build
  end
end
