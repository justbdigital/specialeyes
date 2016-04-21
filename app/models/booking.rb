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
end
