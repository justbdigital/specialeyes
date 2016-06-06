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

class Balance < ActiveRecord::Base
  belongs_to :consumer
  has_many :inner_transactions

  validates_presence_of :consumer
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
