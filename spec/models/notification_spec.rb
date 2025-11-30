require "rails_helper"

RSpec.describe Notification, type: :model do
  context "validations" do
    it "is valid with all required attributes" do
      notification = build(:notification)

      expect(notification).to be_valid
    end

    it "must belong to a user" do
      notification = build(:notification, user: nil)

      expect(notification).not_to be_valid
    end

    it "must have a message" do
      notification = build(:notification, message: nil)

      expect(notification).not_to be_valid
    end

    it "is not valid without a notifiable" do
      notification = build(:notification, notifiable: nil)

      expect(notification).not_to be_valid
    end
  end
end
