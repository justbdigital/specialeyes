# == Schema Information
#
# Table name: bank_accounts
#
#  id             :integer          not null, primary key
#  pro_id         :integer
#  holder_name    :string
#  account_number :string
#  bank_name      :string
#  bank_sort_code :string
#  bank_address   :string
#  postcode       :string
#  country        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :bank_account do
    
  end
end
