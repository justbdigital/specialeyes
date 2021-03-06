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

class Pro < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username

  has_many :treatments, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :daily_schedules, dependent: :destroy

  has_many :vouchers, as: :creator
  has_many :transactions, as: :creator

  has_one :team, foreign_key: :owner_id, dependent: :destroy
  has_one :venue, dependent: :destroy
  has_one :bank_account, dependent: :destroy

  belongs_to :member_of, class_name: Team

  def profile_score
    venue_rating = venue ? venue.rating * 2 : 0
    treatments_count = treatments.count > 10 ? 10 : treatments.count

    @score = (average_discount + reviews_count + venue_rating + treatments_count).to_i
  end

  def booking_this_month
    bookings
      .where(confirmed: true, start_at: Time.now.beginning_of_month..Time.now.end_of_month)
      .count
  end

  def treatment_this_month(treatment_id)
    bookings
      .where(confirmed: true, treatment_id: treatment_id, start_at: Time.now.beginning_of_month..Time.now.end_of_month)
      .sum(:sum)
  end

  def historical_financies
    bookings
      .where(confirmed: true, start_at: (Time.now - 1.year)..Time.now)
      .group_by_month(:start_at, format: "%B %Y")
      .sum(:sum)
  end

  def popular_treatments
    row_bookings = bookings.where(confirmed: true).group_by(&:treatment_id)

    ids = {}.tap do |item|
      row_bookings.each_pair do |treatment_id, bookings|
        item[treatment_id] = bookings.count
      end
    end.sort_by { |_k, v| v }.last(3).map(&:first)

    @treatments = Treatment.where(id: ids)
  end

  def active_for_authentication?
    super && !suspended
  end

  def inactive_message
    'Sorry, this account has been deactivated. Please contact support team.'
  end

  private

  def reviews_count
    if venue
      venue.reviews.count > 10 ? 10 : venue.reviews.count
    else
      0
    end
  end

  def average_discount
    unless treatments.blank?
      discounts = treatments.map { |t| t.price - t.sale_price }
      av_discount = discounts.inject(:+).to_f / discounts.length
      @discount_score ||= av_discount > 50 ? 10 : av_discount / 5
    else
      0
    end
  end
end
