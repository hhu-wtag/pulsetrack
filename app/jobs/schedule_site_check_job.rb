class ScheduleSiteCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.tagged("Scheduler") do
      sites_due = MonitoredSite.ready_for_check

      if sites_due.any?
        Rails.logger.info "Found #{sites_due.count} sites ready for checking."
      else
        Rails.logger.debug "No sites due for check."
        return
      end

      sites_due.each do |site|
        Rails.logger.info "Queuing check for Site ID: #{site.id} (#{site.url})"

        MonitorSiteJob.perform_later(site)

        site.update_column(
          :next_check_at,
          Time.current + site.check_frequency_seconds.seconds
        )
      end

      Rails.logger.info "Batch queuing complete."
    end
  rescue => e
    Rails.logger.error "[Scheduler] CRITICAL FAILURE: #{e.message}"
    Rails.logger.error e.backtrace.first(3).join("\n")
  end
end
