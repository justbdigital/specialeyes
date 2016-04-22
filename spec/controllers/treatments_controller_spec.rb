require 'rails_helper'

RSpec.describe TreatmentsController, type: :controller do
  let!(:pro) { create(:pro) }
  let!(:pro2) { create(:pro) }
  let!(:treatment_group) { create(:treatment_group, pro: pro) }
  let!(:treatment_group2) { create(:treatment_group, pro: pro) }
  let!(:treatment) { create(:treatment, pro: pro, treatment_group: treatment_group) }
  let!(:id) { treatment.id }

  describe 'GET #index' do
    it 'assigns a correct treatment with group and groups with no treatments and renders index template' do
      sign_in pro

      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template :index
      expect(assigns(:treatments_with_groups)).to eq({ treatment_group => [treatment] })
      expect(assigns(:groups)).to eq [treatment_group2]
    end
  end

  describe 'GET #new' do
    before { sign_in pro; get :new }

    it 'assigns a new treatment to @treatment' do
      expect(assigns(:treatment)).to be_a_new(Treatment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'assigns a correct treatment and renders edit template' do
      sign_in pro

      get :edit, id: id
      expect(assigns(:treatment)).to eq treatment
      expect(response).to have_http_status(200)
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    it 'saves the new treatment to db and redirect to treatment' do
      sign_in pro

      expect { post :create, treatment: { title: 'treatmenttitle', sale_price: 33, treatment_group_id: treatment_group.id } }.to change(Treatment, :count).by(1)
      expect(response).to redirect_to treatments_path
    end
  end

  describe 'PATCH #update' do
    it 'updates attributes and renders the treatment template if current user is treatment owner' do
      sign_in pro
      patch :update, id: id, treatment: { title: 'newtitle' }
      treatment.reload
      expect(response).to redirect_to treatments_path
      expect(treatment.title).to eq 'newtitle'
    end

    it 'does not render the treatment template if pro is not signed in' do
      patch :update, id: id
      expect(response).to_not redirect_to treatments_path
    end
  end

  describe 'DELETE #destroy' do
    it 'does not delete group if pro is not signed in' do
      expect { delete :destroy, id: id }.to_not change(Treatment, :count)
    end

    it 'does not delete group if current pro is not an owner' do
      sign_in pro2
      expect { delete :destroy, id: id }.to_not change(Treatment, :count)
    end

    it 'deletes group if current pro is an owner' do
      sign_in pro
      expect { delete :destroy, id: id }.to change(Treatment, :count).by(-1)
    end
  end
end
