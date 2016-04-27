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

require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { is_expected.to belong_to(:pro) }
  it { is_expected.to belong_to(:consumer) }
  it { is_expected.to belong_to(:treatment) }

  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:pro_id) }
end
