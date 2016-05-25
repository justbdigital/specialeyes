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
class BankAccount < ActiveRecord::Base
  belongs_to :pro
  validates_presence_of :pro_id
  validates_uniqueness_of :pro_id
end
