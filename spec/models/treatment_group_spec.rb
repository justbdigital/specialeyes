# == Schema Information
#
# Table name: treatment_groups
#
#  id         :integer          not null, primary key
#  pro_id     :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TreatmentGroup, type: :model do
  it { is_expected.to have_many(:treatments).dependent(:destroy) }
  it { is_expected.to belong_to(:pro) }

  it { is_expected.to validate_presence_of(:pro_id) }
end
