class SiteStatusMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.site_status_mailer.site_down.subject
  #
  def site_down
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.site_status_mailer.site_up.subject
  #
  def site_up
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
