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
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default("0")
#  suspended              :boolean          default("false")
#

FactoryGirl.define do
  factory :pro do
    sequence(:username) { |n| "uniq_code#{n}" }
    sequence(:email) { |n| "emaqqq#{n}@factory.com" }
    password "12345678"
    password_confirmation { |u| u.password }
  end
end
