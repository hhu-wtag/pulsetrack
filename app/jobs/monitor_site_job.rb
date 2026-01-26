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
    Rails.logger.tagged("SiteCheck", "SiteID: #{monitored_site.id}") do
      Rails.logger.info "Starting check for: #{monitored_site.url}"
      result = SiteChecker.new(monitored_site).call

      Rails.logger.info "Result: status=#{result[:status]} | code=#{result[:http_status_code]} | time=#{result[:response_time_ms]}ms"

      monitored_site.check_results.create!(
        status: result[:status],
        http_status_code: result[:http_status_code],
        response_time_ms: result[:response_time_ms],
        error_message: result[:error_message]
      )

      simple_status = STATUS_MAP.fetch(result[:status], :down)
      monitored_site.update!(last_status: simple_status)

      Rails.logger.info "Successfully updated site status to: #{simple_status}"

    rescue => e
      Rails.logger.error "CRITICAL FAILURE for Site #{monitored_site.id}: #{e.message}"
    end
  end
end
