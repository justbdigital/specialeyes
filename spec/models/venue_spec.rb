# == Schema Information
#
# Table name: venues
#
#  id           :integer          not null, primary key
#  pro_id       :integer
#  image        :string
#  name         :string
#  address      :string
#  phone        :string
#  email        :string
#  website      :string
#  primary_type :string
#  description  :text
#  latitude     :float
#  longitude    :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Venue, type: :model do
  it { is_expected.to belong_to(:pro) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:pro_id) }
  it { is_expected.to validate_uniqueness_of(:pro_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
