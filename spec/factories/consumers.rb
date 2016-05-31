# == Schema Information
#
# Table name: consumers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  phone                  :string
#  profile_name           :string
#  postcode               :string
#  female                 :boolean
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
#  image                  :string
#  braintree_customer_id  :integer
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default("0")
#

FactoryGirl.define do
  factory :consumer do
    profile_name { Forgery::Name.first_name }
    first_name { Forgery::Name.first_name }
    last_name { Forgery::Name.last_name }
    phone { '1234567891' }    
    sequence(:email) { |n| "emaqqq#{n}@factory.com" }
    password "12345678"
    password_confirmation { |u| u.password }
  end
end
