class DailySchedulesController < ApplicationController
  def index
    @schedules = DailySchedule.where(pro: current_user).order(:day)
  end

  def destroy
    @schedule = DailySchedule.find(params[:id])
    @schedule.delete
    redirect_to daily_schedules_path, notice: 'schedule deleted'
  end

  def set
    redirect_to daily_schedules_path, notice: 'select days' and return if params[:days].blank?
    redirect_to daily_schedules_path, notice: 'open hours invalid' and return unless hours_valid?

    params[:days].each do |day|
      schedule = set_daily_schedule(day)
      if schedule
        schedule.update(open_at_slot: params.dig(:schedule, :open_at).to_i,
                        close_at_slot: params.dig(:schedule, :close_at).to_i)
      else
        DailySchedule.create(day: day.to_i,
                             pro: current_user,
                             open_at_slot: params.dig(:schedule, :open_at).to_i,
                             close_at_slot: params.dig(:schedule, :close_at).to_i)
      end
    end
    redirect_to daily_schedules_path, notice: 'schedule updated'
  end

  private

  def set_daily_schedule(day)
    DailySchedule.find_by(day: day.to_i, pro: current_user)
  end

  def hours_valid?
    (1..48).cover?(params.dig(:schedule, :open_at).to_i) && (1..48).cover?(params.dig(:schedule, :close_at).to_i)
  end
end
