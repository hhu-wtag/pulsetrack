require 'rails_helper'

RSpec.describe "User", type: :request do
  let!(:user) { create(:user) }
  describe "GET /user" do
    context "when user is not signed in" do
      it "redirects to the login page" do
        get "/user"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before do
        sign_in user
      end

      it "renders the user profile successfully" do
        get "/user"
        expect(response).to have_http_status(:success)
      end
    end
  end
end
