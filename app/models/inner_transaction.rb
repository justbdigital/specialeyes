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
#

class InnerTransaction < ActiveRecord::Base
  belongs_to :creator, polymorphic: true
  has_many :vouchers
  has_many :bookings

  validates_presence_of :amount
  validates_presence_of :creator
end
