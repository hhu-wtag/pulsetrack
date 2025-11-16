require "rails_helper"

RSpec.describe "Notifications", type: :system do
  before do
    driven_by :selenium_headless

    @user = create(:user)
    @old_notification = create(:notification, user: @user, message: "Old Notification")
    sign_in @user
  end

  it "prepends a new notification to the list in real-time" do
    visit home_path

    expect(page).to have_selector("#notifications_list")

    within("#notifications_list") do
      expect(page).to have_content("Old Notification")
      expect(page).to have_css("li", count: 1)
    end

    @new_notification = create(:notification, user: @user, message: "New Notification")

    within("#notifications_list") do
      expect(page).to have_content("New Notification")
      expect(page).to have_content("Old Notification")
      expect(page).to have_css("li", count: 2)
    end

    expect(page.find("#notifications_list li:first-child")).to have_content("New Notification")
  end
end
