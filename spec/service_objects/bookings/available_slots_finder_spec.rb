require 'rails_helper'

RSpec.describe Bookings::AvailableSlotsFinder do
  let!(:consumer) { create(:consumer) }
  let!(:pro) { create(:pro) }
  let!(:daily_schedule) do
    create(:daily_schedule,
           pro: pro,
           open_at_slot: 18,
           close_at_slot: 40,
           day: ::ApplicationHelper::WEEK.key(Time.zone.now.strftime("%A")) + 1)
  end

  let!(:treatment_group) { create(:treatment_group, pro: pro) }

  # 18 slots * 30min/per slot = 9 hours duration should fit into working hours from 9am till 8:30pm
  let!(:treatment) { create(:treatment, treatment_group: treatment_group, pro: pro, duration: '18') }
  let!(:date_in_the_past) { Time.zone.now - 1.day }
  let!(:date) { Time.zone.now + 1.day }
  let!(:id) { treatment.id }
  let!(:am_slots) do
    [OpenStruct.new(start_at: 18), # 18 slots * 30min/per slot = 9am
     OpenStruct.new(start_at: 19), # 19 slots * 30min/per slot = 9:30am
     OpenStruct.new(start_at: 20), # 20 slots * 30min/per slot = 10am
     OpenStruct.new(start_at: 21), # 21 slots * 30min/per slot = 10:30am
     OpenStruct.new(start_at: 22)] # 22 slots * 30min/per slot = 11am
  end

  describe '#am_slots' do
    context 'return available am time slots ' do
      it 'returns the consumer' do
        expect(described_class.new(date, id).am_slots).to eq am_slots
      end
    end

    context 'consumer has not authorization' do
      it 'does not create new consumer' do
        expect(described_class.new(date_in_the_past, id).am_slots).to eq []
      end
    end
  end

  describe '#pm_slots' do
    context 'consumer already has authorization' do
      it 'returns the consumer' do
        expect(described_class.new(date, id).pm_slots).to eq []
      end
    end

    context 'consumer has not authorization' do
      it 'does not create new consumer' do
        expect(described_class.new(date_in_the_past, id).pm_slots).to eq []
      end
    end
  end
end
