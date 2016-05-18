require 'rails_helper'

RSpec.describe Venues::Finder do
  let!(:pro1) { create(:pro) }
  let!(:pro2) { create(:pro) }

  let!(:treatment_group1) { create(:treatment_group, pro: pro1) }
  let!(:treatment_group2) { create(:treatment_group, pro: pro2) }

  let!(:treatment1) { create(:treatment, pro: pro1, treatment_group: treatment_group1, treatment_type: 'new type', sale_price: 22) }
  let!(:treatment2) { create(:treatment, pro: pro2, treatment_group: treatment_group2, treatment_type: 'old style', sale_price: 55) }

  let!(:venue1) { create(:venue, pro: pro1, address: 'London, 35, East') }
  let!(:venue2) { create(:venue, pro: pro2, address: 'New York, 100, West') }

  it 'finds venue by treatment cost and type' do
    result = described_class.new({ cost: '44' }).call
    expect(result).to match_array([venue1])
  end

  it 'finds venue by treatment cost and type' do
    result = described_class.new({ cost: '11' }).call
    expect(result).to match_array([])
  end

  it 'finds venue by treatment cost and type' do
    result = described_class.new({ cost: '66', treatment: 'old' }).call
    expect(result).to match_array([venue2])
  end

  it 'finds venue by treatment cost and type' do
    result = described_class.new({ location: 'London' }).call
    expect(result).to match_array([venue1])
  end

  it 'finds venue by treatment cost and type' do
    result = described_class.new({ date: (Time.zone.now + 1.days) }).call
    expect(result).to match_array([venue1, venue2])
  end

  it 'finds venue by treatment cost and type' do
    result = described_class.new({ date: (Time.zone.now - 1.days) }).call
    expect(result).to match_array([])
  end

  it 'finds all matches' do
    result = described_class.new({ location: 'est' }).call
    expect(result).to match_array([venue2])
  end

  it 'finds all matches' do
    result = described_class.new({ location: 'ondon 35 Eas' }).call
    expect(result).to match_array([venue1])
  end
end
