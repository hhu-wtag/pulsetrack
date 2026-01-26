require 'rails_helper'

RSpec.describe "Teams::Switches", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/teams/switches/create"
      expect(response).to have_http_status(:success)
    end
  end
end
