# == Schema Information
#
# Table name: daily_schedules
#
#  id            :integer          not null, primary key
#  day           :integer
#  open_at_slot  :integer
#  close_at_slot :integer
#  pro_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DailySchedule < ActiveRecord::Base
  belongs_to :pro

  validates_presence_of :pro_id

  validates :open_at_slot, presence: true, inclusion: { in: 1..48 }
  validates :close_at_slot, presence: true, inclusion: { in: 1..48 }
  validates :day, presence: true, inclusion: { in: 1..7 }

  validates_uniqueness_of :day, scope: :pro_id
end
