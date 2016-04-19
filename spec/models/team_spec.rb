# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  it { is_expected.to have_many(:members).class_name('Pro').with_foreign_key('member_of_id') }
  it { is_expected.to belong_to(:owner) }

  it { is_expected.to validate_presence_of(:owner_id) }
  it { is_expected.to validate_uniqueness_of(:owner_id) }
end
