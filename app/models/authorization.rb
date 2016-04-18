# == Schema Information
#
# Table name: authorizations
#
#  id          :integer          not null, primary key
#  consumer_id :integer
#  provider    :string
#  uid         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Authorization < ActiveRecord::Base
  belongs_to :consumer
end
