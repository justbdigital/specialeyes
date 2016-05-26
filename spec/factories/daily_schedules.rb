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

FactoryGirl.define do
  factory :daily_schedule do
    day 1
    open_at_slot 1
    close_at_slot 1
    association :pro, factory: :pro, strategy: :build
  end
end
