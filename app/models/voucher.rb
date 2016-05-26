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

class Voucher < ActiveRecord::Base
  belongs_to :creator, polymorphic: true
  belongs_to :owner, class_name: Consumer

  validates_presence_of :creator
  validates_presence_of :code
  validates_uniqueness_of :code

  after_initialize :set_defaults, if: :new_record?

  scope :used, -> { where(used: true) }

  private

  def set_defaults
    self.code ||= SecureRandom.hex(8)
  end
end
