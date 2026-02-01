class AverageUptimeJob < ApplicationJob
  include ActionView::RecordIdentifier

  queue_as :default

  def perform(monitored_site)
    Rails.logger.tagged("Analytics", "SiteID: #{monitored_site.id}") do
      average = monitored_site.average_response_time
      target_id = dom_id(monitored_site, :average_response_time)

      Rails.logger.info "Recalculated average response time: #{average}ms"

      Rails.logger.debug "Broadcasting update to DOM ID: #{target_id}"

      Turbo::StreamsChannel.broadcast_replace_to(
        monitored_site,
        target: target_id,
        partial: "monitored_sites/avg_time",
        locals: { average: average, monitored_site: monitored_site }
      )

      Rails.logger.info "UI Update Broadcast Complete."
    end
  rescue => e
    Rails.logger.error "FAILED to update average uptime for Site #{monitored_site.id}: #{e.message}"
  end
end
