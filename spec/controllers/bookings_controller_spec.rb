require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:consumer) { create(:consumer) }
  let!(:treatment_group) { create(:treatment_group, pro: pro) }
  let!(:treatment) { create(:treatment, pro: pro, treatment_group: treatment_group) }
  let!(:day_in_the_past) { Time.zone.now - 1.day }
  let!(:start_at) { Time.zone.now + 1.day }

  before do
    request.env["HTTP_REFERER"] = venues_path
  end

  describe 'POST #create' do
    it 'saves the new booking to db and redirect to new transaction path' do
      sign_in consumer

      expect do
        post :create, treat: treatment.id, time: 2, date: start_at
      end.to change(Booking, :count).by(1)
      expect(response).to redirect_to new_transaction_path(treat: treatment.id)
    end

    it 'it does not save new booking if signed in as pro' do
      sign_in pro

      expect do
        post :create, treat: treatment.id, time: 2, date: start_at
      end.to change(Booking, :count).by(0)
      expect(response).to_not redirect_to new_transaction_path
    end

    it 'it does not save new booking if date is in the past' do
      sign_in consumer

      expect do
        post :create, treat: treatment.id, time: 2, date: day_in_the_past
      end.to change(Booking, :count).by(0)
      expect(response).to_not redirect_to new_transaction_path
    end

    it 'it does not save new booking if not signed in' do
      expect do
        post :create, treat: treatment.id, time: 2, date: start_at
      end.to change(Booking, :count).by(0)
      expect(response).to_not redirect_to new_transaction_path
    end
  end
end
