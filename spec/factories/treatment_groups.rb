# == Schema Information
#
# Table name: treatment_groups
#
#  id         :integer          not null, primary key
#  pro_id     :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :treatment_group do
    name { Forgery::Name.first_name }
    association :pro, factory: :pro, strategy: :build
  end
end
