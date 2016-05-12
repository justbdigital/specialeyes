# == Schema Information
#
# Table name: balances
#
#  id          :integer          not null, primary key
#  consumer_id :integer
#  active      :boolean          default("true")
#  amount      :decimal(16, 2)   default("0.0")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :balance do
    amount "9.99"
    consumer nil
    active false
  end
end
