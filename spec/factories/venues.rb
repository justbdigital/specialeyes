# == Schema Information
#
# Table name: venues
#
#  id           :integer          not null, primary key
#  pro_id       :integer
#  image        :string
#  name         :string
#  address      :string
#  phone        :string
#  email        :string
#  website      :string
#  primary_type :string
#  description  :text
#  latitude     :float
#  longitude    :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :venue do
    name { Forgery::Name.first_name }
    association :pro, factory: :pro, strategy: :build
  end
end
