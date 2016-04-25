class BookingService
  def initialize(date, treatment_id)
    @date = date
    @treatment_id = treatment_id
    update_slots!
  end

  def am_slots
    slots.select { |slot| slot.start_at < 26 }
  end

  def pm_slots
    slots.select { |slot| slot.start_at >= 26 }
  end

  private

  def treatment
    @treatment ||= ::Treatment.find(@treatment_id)
  end

  def specialist
    @spec ||= treatment.pro
  end

  def bookings
    arel = Booking.arel_table

    @bookings ||= specialist
                  .bookings
                  .where(arel[:start_at]
                  .lteq(@date.midnight + 1.day)
                  .and(arel[:start_at]
                  .gteq(@date.midnight)))
  end

  def raw_slots
    @raw_slots ||= Array.new((20 - 9) * 2, 1) # working hours 9am till 8pm
  end

  def slots
    @free_slots = []
    raw_slots.each_with_index do |slot, index|
      duration = treatment.duration.to_i
      frame = raw_slots[index, duration]
      if frame.count == duration && !frame.any?(&:zero?)
        @free_slots << OpenStruct.new(start_at: (18 + index)) # 18 == number of 30min intervals in 9am
      end
    end
      @date > Time.zone.now ? @free_slots : []
  end

  def update_slots!
    bookings.each do |booking|
      time = (booking.start_at - booking.start_at.midnight) / 60 / 60
      fractional = (time % 1) * 60 / 30

      start = time.to_i * 2 + fractional.to_i - 18
      length = booking.treatment.duration.to_i

      raw_slots[start, length] = Array.new(length, 0) # turn 0 to 1
    end
  end
end
