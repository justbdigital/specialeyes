require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:pro2) { create(:pro) }

  let!(:team) { create(:team, owner: pro) }
  let!(:id) { team.id }

  describe 'GET #check_for_team' do
    it 'assigns the requested team to @team and render show if owner signed in' do
      sign_in pro

      get :check_for_team, id: id
      expect(assigns(:team)).to eq team
      expect(response).to render_template :show
    end

    it 'does not assign the requested team to @team if now signed in' do
      get :check_for_team, id: id
      expect(assigns(:team)).to eq nil
    end
  end

  describe 'POST #create' do
    it 'is possible to save only one team per owner' do
      sign_in pro

      expect(response).to_not redirect_to team_path(Team.last)
    end

    it 'saves the new team to db and redirect to team' do
      sign_in pro2

      expect { post :create, team: { name: 'teamname' } }.to change(Team, :count).by(1)
      expect(response).to redirect_to team_path(Team.last)
    end
  end
end
