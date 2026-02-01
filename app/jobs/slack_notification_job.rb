class SlackNotificationJob < ApplicationJob
  queue_as :default

  limits_concurrency key: ->(site) { site.id }, duration: 10.seconds

  def perform(site)
    Notifications::SlackService.notify(site)
  end
end
