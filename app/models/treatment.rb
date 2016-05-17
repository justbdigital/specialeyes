# == Schema Information
#
# Table name: treatments
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pro_id             :integer
#  sale_price         :integer
#  price              :integer
#  duration           :string
#  treatment_type     :string
#  treatment_group_id :integer
#

class Treatment < ActiveRecord::Base
  TREATTYPE = ['Eyelash and Eyebrow Treatments', 'Eyelash Extentions', 'New Treatment', 'Old Treatment', 'First', 'Last'].freeze
  DURATIONS = { 1 => '30 min', 2 => '1 h', 3 => '1 h 30 min', 4 => '2 h', 5 => '2 h 30 min', 6 => '3 h', 7 => '3 h 30 min',
                8 => '4 h', 9 => '4 h 30 min', 10 => '5 h', 11 => '5 h 30 min', 12 => '6 h', 13 => '6 h 30 min', 14 => '7 h',
                15 => '7 h 30 min', 16 => '8 h', 17 => '8 h 30 min', 18 => '9:00', 19 => '9:30', 20 => '10:00', 21 => '10:30',
                22 => '11:00', 23 => '11:30', 24 => '12:00', 25 => '12:30', 26 => '13:00', 27 => '13:30', 28 => '14:00', 29 => '14:30',
                30 => '15:00', 31 => '15:30', 32 => '16:00', 33 => '16:30', 34 => '17:00', 35 => '17:30', 36 => '18:00', 37 => '18:30',
                38 => '19:00', 39 => '19:30', 40 => '20:00' }.freeze

  belongs_to :pro
  belongs_to :treatment_group

  has_many :bookings, dependent: :destroy

  validates_presence_of :pro_id
  validates_presence_of :title
  validates_presence_of :treatment_group_id
  validates_presence_of :sale_price
end
