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

require 'rails_helper'

RSpec.describe Voucher, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
