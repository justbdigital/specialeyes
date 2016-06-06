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

require 'rails_helper'

RSpec.describe InnerTransaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
