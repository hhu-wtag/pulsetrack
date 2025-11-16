require 'rails_helper'

RSpec.describe "MonitoredSites", type: :request do
  let!(:user) { create(:user) }
  let!(:site) { create(:monitored_site, user: user) }

  describe "GET /monitored_sites" do
    context "when user is not signed in" do
      it 'redirects to the login page' do
        get monitored_sites_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before do
        sign_in user
      end

      it 'renders the dashboard successfully' do
        get monitored_sites_path

        expect(response).to have_http_status(:success)
      end

      it 'shows the users own sites' do
        get monitored_sites_path

        expect(response.body).to include(site.name)
      end

      it "doesn't show another user's sites" do
        another_user = create(:user)
        another_site = create(:monitored_site, user: another_user)

        get monitored_sites_path

        expect(response.body).to include(site.name)
        expect(response.body).not_to include(another_site.name)
      end
    end
  end

  describe "POST /monitored_sites" do
    let(:valid_params) do
      {
        monitored_site: {
          name: "New site",
          url: "https://example.com"
        }
      }
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        expect {
          post monitored_sites_path, params: valid_params
        }.not_to change(MonitoredSite, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in" do
      before do
        sign_in user
      end

      context "with valid parameters" do
        it "creates a new monitored site" do
          expect {
            post monitored_sites_path, params: valid_params
          }.to change(MonitoredSite, :count).by(1)
        end

        it "associates the new site with the current user" do
          post monitored_sites_path, params: valid_params
          expect(MonitoredSite.last.user).to eq(user)
        end

        it "redirects to the sites list(or dashboard)" do
          post monitored_sites_path, params: valid_params
          expect(response).to redirect_to(monitored_sites_path)
        end
      end
    end
  end
end
