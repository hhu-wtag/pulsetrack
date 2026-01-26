require 'rails_helper'

RSpec.describe "MonitoredSites", type: :request do
  # 1. Setup the core entities
  let!(:user) { create(:user) }
  let!(:team) { create(:team) }
  # Ensure the user is actually IN the team
  let!(:membership) { create(:team_membership, user: user, team: team, role: :admin) }

  # 2. Update the site to belong to the team (FactoryBot should now use 'team')
  let!(:site) { create(:monitored_site, team: team) }

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
        # 3. Simulate the 'Switch Team' session priming
        # We manually set the session so current_team is predictable
        post teams_switches_path(team_id: team.id)
      end

      it 'renders the dashboard successfully' do
        get monitored_sites_path
        expect(response).to have_http_status(:success)
      end

      it 'shows the sites belonging to the current team' do
        get monitored_sites_path
        expect(response.body).to include(site.name)
      end

      it "doesn't show sites from a team the user isn't currently viewing" do
        other_team = create(:team)
        create(:team_membership, user: user, team: other_team)
        other_site = create(:monitored_site, team: other_team, name: "Secret Site")

        get monitored_sites_path

        expect(response.body).to include(site.name)
        expect(response.body).not_to include("Secret Site")
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

    context "when user is signed in" do
      before do
        sign_in user
        # Prime the session so the controller knows which team to assign the site to
        post teams_switches_path(team_id: team.id)
      end

      context "with valid parameters" do
        it "creates a new monitored site" do
          expect {
            post monitored_sites_path, params: valid_params
          }.to change(MonitoredSite, :count).by(1)
        end

        it "associates the new site with the current team" do
          post monitored_sites_path, params: valid_params
          # We check the 'team' association now, not 'user'
          expect(MonitoredSite.last.team).to eq(team)
        end

        it "redirects to the site show page (or dashboard)" do
          post monitored_sites_path, params: valid_params
          # Adjust this based on your actual controller redirect
          expect(response).to redirect_to(monitored_sites_path)
        end
      end
    end
  end
end
