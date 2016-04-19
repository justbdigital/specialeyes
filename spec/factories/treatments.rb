# == Schema Information
#
# Table name: treatments
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pro_id             :integer
#  sale_price         :integer
#  price              :integer
#  duration           :string
#  treatment_type     :string
#  treatment_group_id :integer
#

FactoryGirl.define do
  factory :treatment do
    title { Forgery::Name.first_name }
    association :pro, factory: :pro, strategy: :build
    association :treatment_group, factory: :treatment_group, strategy: :build
  end
end
