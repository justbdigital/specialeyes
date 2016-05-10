# == Schema Information
#
# Table name: vouchers
#
#  id           :integer          not null, primary key
#  creator_id   :integer
#  creator_type :string
#  owner_id     :integer
#  code         :string
#  paid         :boolean          default("false")
#  used         :boolean          default("false")
#  amount       :decimal(16, 2)
#  valid_till   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :voucher do
    creator_id 1
    creator_type "MyString"
    owner_id 1
    paid false
    amount "9.99"
    valid_till "2016-05-09 15:34:08"
  end
end
