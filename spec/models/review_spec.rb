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

require 'rails_helper'

RSpec.describe Review, type: :model do
  it { is_expected.to belong_to(:booking) }
  it { is_expected.to belong_to(:consumer) }
  it { is_expected.to belong_to(:venue) }

  it { is_expected.to validate_presence_of(:consumer_id) }
  it { is_expected.to validate_presence_of(:venue_id) }
  it { is_expected.to validate_presence_of(:ambiance) }
  it { is_expected.to validate_presence_of(:cleanliness) }
  it { is_expected.to validate_presence_of(:staff) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_inclusion_of(:ambiance).in_range(1..5) }
  it { is_expected.to validate_inclusion_of(:cleanliness).in_range(1..5) }
  it { is_expected.to validate_inclusion_of(:staff).in_range(1..5) }
  it { is_expected.to validate_inclusion_of(:value).in_range(1..5) }
end
