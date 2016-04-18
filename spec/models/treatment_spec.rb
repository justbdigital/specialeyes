# == Schema Information
#
# Table name: treatments
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pro_id             :integer
#  sale_price         :integer
#  price              :integer
#  duration           :string
#  treatment_type     :string
#  treatment_group_id :integer
#

require 'rails_helper'

RSpec.describe Treatment, type: :model do
  it { is_expected.to belong_to(:pro) }
  it { is_expected.to belong_to(:treatment_group) }

  it { is_expected.to validate_presence_of(:pro_id) }
end
