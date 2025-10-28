require "test_helper"

class SiteStatusMailerTest < ActionMailer::TestCase
  test "site_down" do
    mail = SiteStatusMailer.site_down
    assert_equal "Site down", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "site_up" do
    mail = SiteStatusMailer.site_up
    assert_equal "Site up", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
