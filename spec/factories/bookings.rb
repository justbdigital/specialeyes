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

FactoryGirl.define do
  factory :booking do
    start_at Time.zone.now + 1.day
    sum 1
    paid false
    association :pro, factory: :pro, strategy: :build
    association :consumer, factory: :consumer, strategy: :build
    association :treatment, factory: :treatment, strategy: :build
  end
end
