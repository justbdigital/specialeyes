require 'rails_helper'

RSpec.describe BankAccountsController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:pro2) { create(:pro) }
  let!(:bank_account) { create(:bank_account, pro: pro) }
  let!(:id) { bank_account.id }

  describe 'GET #new' do
    before { sign_in pro; get :new }

    it 'assigns a new bank_account to @account' do
      expect(assigns(:account)).to be_a_new(BankAccount)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'assigns a correct bank_account and renders edit template' do
      sign_in pro

      get :edit, id: id
      expect(assigns(:account)).to eq bank_account
      expect(response).to have_http_status(200)
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    it 'is possible to save only one accont per person' do
      sign_in pro

      expect(response).to_not redirect_to edit_bank_account_url(bank_account)
    end

    it 'saves the new bank_account to db and redirect to edit bank_account' do
      sign_in pro2

      expect { post :create, bank_account: { holder_name: 'bank_accountholder_name' } }.to change(BankAccount, :count).by(1)
      expect(response).to redirect_to edit_bank_account_url(BankAccount.last)
    end
  end

  describe 'PATCH #update' do
    it 'updates attributes and renders edit bank_account template if current user is bank_account owner' do
      sign_in pro
      patch :update, id: id, bank_account: { holder_name: 'newholder_name' }
      bank_account.reload
      expect(response).to redirect_to edit_bank_account_url(bank_account)
      expect(bank_account.holder_name).to eq 'newholder_name'
    end

    it 'does not render the bank_account template if pro is not signed in' do
      patch :update, id: id
      expect(response).to_not redirect_to edit_bank_account_url(bank_account)
    end
  end
end
