require 'rails_helper'

RSpec.describe TreatmentGroupsController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:pro_2) { create(:pro) }
  let!(:group) { create(:treatment_group, pro: pro) }
  let!(:id) { group.id }

  describe 'GET #edit' do
    it 'saves the new group to db and redirect to treatments' do
      sign_in pro

      get :edit, id: id
      # expect(assigns(:treatment_group)).to eq group
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    it 'saves the new group to db and redirect to treatments' do
      sign_in pro

      expect { post :create, treatment_group: attributes_for(:treatment_group) }.to change(TreatmentGroup, :count).by(1)
      expect(response).to redirect_to treatments_path
    end
  end

  describe 'PATCH #update' do
    it 'updates attributes and renders the treatments template if current user is group owner' do
      sign_in pro
      patch :update, id: id, treatment_group: { name: 'new name' }
      expect(response).to redirect_to treatments_path
      group.reload
      expect(group.name).to eq 'new name'
    end

    it 'does not render the treatments template if pro is not signed in' do
      patch :update, id: id
      expect(response).to_not redirect_to treatments_path
    end
  end

  describe 'DELETE #destroy' do
    it 'does not delete group if pro is not signed in' do
      expect { delete :destroy, id: id }.to_not change(TreatmentGroup, :count)
    end

    it 'does not delete group if current pro is not an owner' do
      sign_in pro_2
      expect { delete :destroy, id: id }.to_not change(TreatmentGroup, :count)
    end

    it 'deletes group if current pro is an owner' do
      sign_in pro
      expect { delete :destroy, id: id }.to change(TreatmentGroup, :count).by(-1)
    end
  end
end
