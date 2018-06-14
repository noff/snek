require 'rails_helper'

RSpec.describe RatingsController, type: :controller do

  describe "GET #top" do
    it "returns http success" do
      get :top
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #national" do
    it "returns http success" do
      get :national
      expect(response).to have_http_status(:success)
    end
  end

end
