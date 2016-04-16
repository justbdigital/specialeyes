# == Schema Information
#
# Table name: treatment_groups
#
#  id         :integer          not null, primary key
#  pro_id     :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TreatmentGroup < ActiveRecord::Base
  has_many :treatments, dependent: :destroy

  belongs_to :pro
  validates_presence_of :pro_id
end
