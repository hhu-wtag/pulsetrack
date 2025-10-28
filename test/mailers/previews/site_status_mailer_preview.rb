# Preview all emails at http://localhost:3000/rails/mailers/site_status_mailer
class SiteStatusMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/site_status_mailer/site_down
  def site_down
    SiteStatusMailer.site_down
  end

  # Preview this email at http://localhost:3000/rails/mailers/site_status_mailer/site_up
  def site_up
    SiteStatusMailer.site_up
  end
end
