require "rails_helper"

RSpec.describe MonitoredSite, type: :model do
  context "validations" do
    it "is valid with all required attributes" do
      site = build(:monitored_site)

      expect(site).to be_valid
    end

    it "is not valid without name attribute" do
      site = build(:monitored_site, name: nil)

      expect(site).not_to be_valid
    end

    it "is not valid without a url" do
      site = build(:monitored_site, url: nil)

      expect(site).not_to be_valid
    end

    it "is not valid without a team" do
      site = build(:monitored_site, team: nil)

      expect(site).not_to be_valid
    end
  end

  context "defaults" do
    it "defaults last_status to 'pending' on creation" do
      site = create(:monitored_site)

      expect(site.last_status).to eq('pending')
    end
  end
end
