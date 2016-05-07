require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:consumer) { create(:consumer) }
  let!(:venue) { create(:venue, pro: pro) }

  describe 'GET #new' do
    it 'renders new view' do
      sign_in consumer
      get :new
      expect(response).to render_template :new
    end

    it 'renders new view' do
      sign_in pro
      get :new
      expect(response).to_not render_template :new
    end
  end

  describe 'POST #create' do
    it 'saves the new review to db and redirect to review' do
      sign_in consumer

      expect { post :create, review: { staff: 1, value: 1, ambiance: 1, cleanliness: 1 }, venue: venue.id }.to change(Review, :count).by(1)
      expect(response).to redirect_to venue_path(venue)
    end

    it 'is possible to save only one review per owner' do
      sign_in pro

      expect { post :create, review: { staff: 1, value: 1, ambiance: 1, cleanliness: 1 }, venue: venue.id }.to change(Review, :count).by(0)
    end
  end
end
