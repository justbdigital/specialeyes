require 'rails_helper'

RSpec.describe VenuesController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:pro2) { create(:pro) }
  let!(:venue) { create(:venue, pro: pro) }
  let!(:id) { venue.name }

  describe 'GET #new' do
    before { sign_in pro; get :new }

    it 'assigns a new venue to @venue' do
      expect(assigns(:venue)).to be_a_new(Venue)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'assigns a correct venue and renders edit template' do
      sign_in pro

      get :edit, id: id
      expect(assigns(:venue)).to eq venue
      expect(response).to have_http_status(200)
      expect(response).to render_template :edit
    end
  end

  describe 'GET #show' do
    it 'assigns the requested venue to @venue for anyone without sign in' do
      get :show, id: id
      expect(assigns(:venue)).to eq venue
    end
  end

  describe 'POST #create' do
    it 'saves the new venue to db and redirect to venue' do
      sign_in pro2

      expect { post :create, venue: { name: 'venuename' } }.to change(Venue, :count).by(1)
      expect(response).to redirect_to edit_venue_path(Venue.last)
    end

    it 'is possible to save only one venue per owner' do
      sign_in pro

      expect { post :create, venue: { name: 'venuename' } }.to change(Venue, :count).by(0)
    end
  end

  describe 'PATCH #update' do
    it 'updates attributes and renders the venue template if current user is venue owner' do
      sign_in pro
      patch :update, id: id, venue: { name: 'newname' }
      venue.reload
      expect(response).to redirect_to edit_venue_path(venue)
      expect(venue.name).to eq 'newname'
    end

    it 'does not render the venue template if pro is not signed in' do
      patch :update, id: id
      expect(response).to_not redirect_to edit_venue_path
    end
  end
end
