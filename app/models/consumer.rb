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
#  suspended              :boolean          default("false")
#

class Consumer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook]

  has_many :authorizations, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :invitations, dependent: :destroy, class_name: 'Pro', as: :invited_by

  has_many :vouchers, as: :creator
  has_many :transactions, as: :creator

  has_many :gifts, class_name: 'Voucher', foreign_key: :owner_id, dependent: :destroy
  has_one :balance, dependent: :destroy

  before_validation :validate_phone_number, on: [:create, :update]

  validates_presence_of :first_name
  validates_presence_of :phone

  mount_uploader :image, ImageUploader

  def has_payment_info?
    braintree_customer_id
  end

  def block_from_invitation?
    false
  end

  def active_for_authentication?
    super && !suspended
  end

  def inactive_message
    'Sorry, this account has been deactivated. Please contact support team.'
  end

  private

  def validate_phone_number
    errors.add(:phone, "please enter 10 digits excluding + and 0") if phone && !authorizations.any? && phone.length != 10
  end
end
