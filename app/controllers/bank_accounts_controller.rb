class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:edit, :update]

  def new
    authorize BankAccount
    @account = BankAccount.new
  end

  def edit
    authorize @account
  end

  def create
    @account = BankAccount.new(account_params.merge(pro: current_user))
    authorize @account
    if @account.save
      redirect_to edit_bank_account_url(@account), notice: 'Bank Account Created'
    else
      redirect_to :back, notice: @account.errors.full_messages.join(', ')
    end
  end

  def update
    authorize @account
    if @account.update(account_params)
      redirect_to edit_bank_account_url(@account), notice: 'Bank Account Updated'
    else
      redirect_to :back, notice: @account.errors.full_messages.join(', ')
    end
  end

  private

  def set_account
    @account = BankAccount.find(params[:id])
  end

  def account_params
    params.require(:bank_account).permit(:holder_name, :account_number, :bank_name, :bank_sort_code, :bank_address, :postcode, :country)
  end
end
