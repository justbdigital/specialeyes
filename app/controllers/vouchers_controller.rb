class VouchersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gift, only: [:add_gift]
  before_action :check_gift!, only: [:add_gift]

  def update
  end

  def add_gift
    authorize @gift
    update_balance_and_gift
    redirect_to :back, notice: 'Added successfully'
  end

  def buy_gift_card
    authorize Voucher
  end

  private

  def check_gift!
    redirect_to :back, alert: 'Gift has been already added!' if set_gift.used
  end

  def set_gift
    @gift ||= Voucher.find_by(code: params[:gift][:code])
  end

  def update_balance_and_gift
    Voucher.transaction do
      @gift.update(owner: current_user, used: true)
      balance = current_user.balance
      balance.amount += @gift.amount
      balance.save
      InnerTransaction.create(creator: current_user, amount: @gift.amount, balance: balance, sign: 'positive')
    end
  end
end
