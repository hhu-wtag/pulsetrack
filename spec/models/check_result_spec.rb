require "rails_helper"

RSpec.describe CheckResult, type: :model do
  context "validations" do
    it "is valid with all required attributes" do
      check_result = build(:check_result)

      expect(check_result).to be_valid
    end

    it "must belong to a monitored_site" do
      check_result = build(:check_result, monitored_site: nil)

      expect(check_result).not_to be_valid
    end

    it "must have a status" do
      check_result = build(:check_result, status: nil)

      expect(check_result).not_to be_valid
    end
  end
end
