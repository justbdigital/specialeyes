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

class InnerTransaction < ActiveRecord::Base
  SIGN = ['positive', 'negative'].freeze

  belongs_to :creator, polymorphic: true
  has_many :vouchers
  has_many :bookings
  belongs_to :balance

  validates_presence_of :amount
  validates_presence_of :creator
  validates_presence_of :sign

  before_validation :validate_sign, on: [:create]

  private

  def validate_sign
    errors.add(:sign, 'sigh should be negative or positive') if sign && !SIGN.include?(sign)
  end
end
