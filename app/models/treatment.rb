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
#  featured           :boolean          default("false")
#

class Treatment < ActiveRecord::Base
  belongs_to :pro
  belongs_to :treatment_group

  has_many :bookings, dependent: :destroy

  validates_presence_of :pro_id
  validates_presence_of :title
  validates_presence_of :treatment_group_id
  validates_presence_of :sale_price
end
