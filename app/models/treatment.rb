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
  TREATTYPE = ['Eyelash and Eyebrow Treatments', 'Eyelash Extentions'].freeze
  DURATIONS = ['15 min', '30 min', '45 min', '1 h', '1 h 15 min', '1 h 30 min', '1 h 45 min', '2 h', '2 h 15 min', '1 h 15 min',
               '1 h 30 min', '1 h 45 min', '3 h', '3 h 15 min', '3 h 30 min', '3 h 45 min', '4 h', '4 h 15 min', '4 h 30 min',
               '4 h 45 min', '5 h', '5 h 15 min', '5 h 30 min', '5 h 45 min', '6 h', '6 h 15 min', '6 h 30 min', '6 h 45 min', '7 h',
               '7 h 15 min', '7 h 30 min', '7 h 45 min', '8 h', '8 h 15 min', '8 h 30 min', '8 h 45 min', '9 h'].freeze

  belongs_to :pro
  belongs_to :treatment_group

  validates_presence_of :pro_id
end
