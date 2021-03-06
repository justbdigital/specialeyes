# == Schema Information
#
# Table name: bookings
#
#  id                   :integer          not null, primary key
#  start_at             :datetime
#  sum                  :integer
#  pro_id               :integer
#  consumer_id          :integer
#  treatment_id         :integer
#  paid                 :boolean          default("false")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  confirmed            :boolean          default("false")
#  completed            :boolean          default("false")
#  inner_transaction_id :integer
#

require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { is_expected.to belong_to(:pro) }
  it { is_expected.to belong_to(:consumer) }
  it { is_expected.to belong_to(:treatment) }

  it { is_expected.to have_many(:reviews).dependent(:destroy) }

  it 'should validate presence of treatment_id and date not to be in the past' do
    @pro = FactoryGirl.create(:pro)
    @consumer = create(:consumer)
    @group = FactoryGirl.create(:treatment_group, pro: @pro)
    @treatment = FactoryGirl.create(:treatment, pro: @pro, treatment_group: @group)

    @booking1 = FactoryGirl.build(:booking, pro: @pro, consumer: @consumer, start_at: Time.zone.now + 1.day)
    expect(@booking1).not_to be_valid
    @booking1.errors.full_messages.should include("Treatment can't be blank")

    @booking2 = FactoryGirl.build(:booking, pro: @pro, start_at: Time.zone.now - 3.day)
    expect(@booking2).not_to be_valid
    @booking2.errors.full_messages.should include("Start at Date can't be in the past")
  end

  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:pro_id) }
end
