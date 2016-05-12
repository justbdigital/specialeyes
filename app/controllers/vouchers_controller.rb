class VouchersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gift
  before_action :check_gift!

  def update
  end

  def add_gift
    authorize @gift
    update_balance_and_gift
    redirect_to :back, notice: 'Added successfully'
  end

  private

  def check_gift!
    redirect_to :back, alert: 'Gift has been already added!' if set_gift.used
  end

  def set_gift
    @gift ||= Voucher.find_by(code: params[:gift][:code])
  end

  def update_balance_and_gift
    ActiveRecord::Base.transaction do
      @gift.update(owner: current_user, used: true)
      balance = current_user.balance
      balance.amount += @gift.amount
      balance.save
    end
  end
end
