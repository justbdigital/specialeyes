# == Schema Information
#
# Table name: pros
#
#  id                     :integer          not null, primary key
#  username               :string
#  business_name          :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  member_of_id           :integer
#

require 'rails_helper'

RSpec.describe Pro, type: :model do
  it { is_expected.to have_one(:venue).dependent(:destroy) }
  it { is_expected.to have_one(:team).dependent(:destroy) }
  it { is_expected.to have_many(:treatments).dependent(:destroy) }
  it { is_expected.to have_one(:bank_account).dependent(:destroy) }
  it { is_expected.to belong_to(:member_of) }

  it { is_expected.to validate_presence_of(:username) }
end
