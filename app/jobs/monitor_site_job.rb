class MonitorSiteJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError

  STATUS_MAP = {
    up: :up,
    down: :down,
    timed_out: :down, # A timeout means it's down
    error: :down # An error means it's down
  }.freeze

  def perform(monitored_site)
    result = SiteChecker.new(monitored_site).call

    granular_status = result[:status]

    puts "Monitoring result for site #{monitored_site.id}: #{result.inspect} - #{monitored_site.check_results}"

    monitored_site.check_results.create!(
      status: granular_status,
      http_status_code: result[:http_status_code],
      response_time_ms: result[:response_time_ms],
      error_message: result[:error_message]
    )

    simple_status = STATUS_MAP.fetch(result[:status], :down)

    monitored_site.update!(last_status: simple_status)

  rescue => e
    Rails.logger.error "Failed to monitor site #{monitored_site.id}: #{e.message}"
  end
end
