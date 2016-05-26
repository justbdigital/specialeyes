# == Schema Information
#
# Table name: daily_schedules
#
#  id            :integer          not null, primary key
#  day           :integer
#  open_at_slot  :integer
#  close_at_slot :integer
#  pro_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe DailySchedule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
