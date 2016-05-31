class BalancesController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize Balance
    @balance = Balance.new(consumer: current_user)
    if @balance.save
      redirect_to :gifts_balance
    else
      redirect_to :back, notice: @balance.errors.full_messages.join(', ')
    end
  end

  def show
    @balance = current_user.balance || Balance.create(consumer: current_user)
    authorize @balance
    @gifts = current_user.gifts.used
    @vouchers = current_user.vouchers
  end
end
