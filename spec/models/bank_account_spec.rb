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

require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { is_expected.to belong_to(:pro) }

  it { is_expected.to validate_presence_of(:pro_id) }
  it { is_expected.to validate_uniqueness_of(:pro_id) }
end
