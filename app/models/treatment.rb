# == Schema Information
#
# Table name: treatments
#
#  id          :integer          not null, primary key
#  title       :string
#  kind        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Treatment < ActiveRecord::Base
end
