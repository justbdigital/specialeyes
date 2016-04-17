class BankAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    @account = BankAccount.new
  end

  def edit
    @account = current_user.bank_account
  end

  def create
    @account = BankAccount.new(account_params.merge(pro: current_user))
    if @account.save
      redirect_to edit_bank_account_url(@account), notice: 'Bank Account Created'
    else
      redirect_to :back, notice: @account.errors.full_messages.join(', ')
    end
  end

  def update
    @account = BankAccount.find(params[:id])
    if @account.pro == current_user && @account.update(account_params)
      redirect_to edit_bank_account_url(@account), notice: 'Bank Account Updated'
    else
      redirect_to :back, notice: @account.errors.full_messages.join(', ')
    end
  end

  private

  def account_params
    params.require(:bank_account).permit(:holder_name, :account_number, :bank_name, :bank_sort_code, :bank_address, :postcode, :country)
  end
end
