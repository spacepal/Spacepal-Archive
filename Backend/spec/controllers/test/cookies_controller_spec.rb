require 'rails_helper'

RSpec.describe Test::CookiesController, type: :controller do

  describe "GET #get" do
    it "returns http success" do
      get :get
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #set" do
    it "returns http success" do
      get :set
      expect(response).to have_http_status(:success)
    end
  end

end
