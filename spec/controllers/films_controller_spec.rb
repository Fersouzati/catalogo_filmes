require 'rails_helper'

RSpec.describe FilmsController, type: :controller do
   include Devise::Test::ControllerHelpers
    let(:user) { create(:user) }
    let(:film) { create(:film, user: user) }

  describe "GET #index" do
    it "retorna sucesso" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    before { sign_in user }

    it "cria um novo filme" do
      expect {
        post :create, params: { film: attributes_for(:film) }
      }.to change(Film, :count).by(1)
    end
  end

  describe "DELETE #destroy" do
    before { sign_in user }

    it "remove o filme" do
      film 
      expect {
        delete :destroy, params: { id: film.id }
      }.to change(Film, :count).by(-1)
    end
  end
end