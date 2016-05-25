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
#  postcode     :string
#

class Venue < ActiveRecord::Base
  is_impressionable

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? || obj.postcode.present? && obj.postcode_changed? }

  belongs_to :pro
  has_many :reviews, dependent: :destroy

  validates_presence_of :pro_id
  validates_uniqueness_of :pro_id

  validates_presence_of :name
  validates_uniqueness_of :name

  mount_uploader :image, ImageUploader

  def to_param
    name
  end

  def rating
    stars = Review.where(venue: self).pluck(:staff, :value, :ambiance, :cleanliness).flatten
    stars.blank? ? 0 : stars.inject(:+).to_f / stars.length
  end

  def rating_more(rate)
    rating >= rate
  end

  def full_address
    "#{address}, #{postcode}"
  end
end
