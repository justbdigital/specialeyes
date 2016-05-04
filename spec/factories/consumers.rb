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
#

FactoryGirl.define do
  factory :consumer do
    profile_name { Forgery::Name.first_name }
    sequence(:email) { |n| "emaqqq#{n}@factory.com" }
    password "12345678"
    password_confirmation { |u| u.password }
  end
end
