# == Schema Information
#
# Table name: inner_transactions
#
#  id           :integer          not null, primary key
#  amount       :decimal(16, 2)
#  creator_id   :integer
#  creator_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  balance_id   :integer
#  sign         :string
#

FactoryGirl.define do
  factory :inner_transaction do
    amount "9.99"
    creator nil
  end
end
