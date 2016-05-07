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

FactoryGirl.define do
  factory :review do
    association :consumer, factory: :consumer, strategy: :build
    association :booking, factory: :booking, strategy: :build
    association :venue, factory: :venue, strategy: :build
    ambiance 1
    cleanliness 1
    staff 1
    value 1
    comment "MyText"
  end
end
