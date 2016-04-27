# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  start_at     :datetime
#  sum          :integer
#  pro_id       :integer
#  consumer_id  :integer
#  treatment_id :integer
#  paid         :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Booking < ActiveRecord::Base
  belongs_to :pro
  belongs_to :consumer
  belongs_to :treatment

  validates_presence_of :pro_id
  validates_presence_of :start_at
  validates_uniqueness_of :start_at, scope: :treatment_id, unless: Proc.new { |b| b.treatment_id.blank? }
  validates_uniqueness_of :start_at, scope: :pro_id, if: Proc.new { |b| b.treatment_id.blank? }

  before_validation :validate_treatment, if: :consumer_id
  before_validation :validateee_start_at, on: :create

  private

  def validateee_start_at
    errors.add(:start_at, "Date can't be in the past") if start_at && start_at < Time.zone.now
  end

  def validate_treatment
    errors.add(:treatment_id, "can't be blank") if treatment_id.nil?
  end
end
