# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  booking_id  :integer
#  consumer_id :integer
#  venue_id    :integer
#  ambiance    :integer
#  cleanliness :integer
#  staff       :integer
#  value       :integer
#  comment     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Review < ActiveRecord::Base
  belongs_to :booking
  belongs_to :consumer
  belongs_to :venue

  validates_presence_of :consumer_id
  validates_presence_of :venue_id

  validates :ambiance, presence: true, inclusion: { in: 1..5 }
  validates :cleanliness, presence: true, inclusion: { in: 1..5 }
  validates :staff, presence: true, inclusion: { in: 1..5 }
  validates :value, presence: true, inclusion: { in: 1..5 }
end
