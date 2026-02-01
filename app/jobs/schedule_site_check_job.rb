class ScheduleSiteCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sites_due = MonitoredSite.ready_for_check

    if sites_due.any?
      Rails.logger.info "[Scheduler] Found #{sites_due.count} sites ready for checking."
    else
      Rails.logger.debug "[Scheduler] No sites due for check at this time."
      return
    end

    sites_due.each do |site|
      Rails.logger.info "[Scheduler] Queuing check for: #{site.url} (ID: #{site.id})"
      MonitorSiteJob.perform_later(site)

      site.update_column(
        :next_check_at,
        Time.current + site.check_frequency_seconds.seconds
      )
    end

    Rails.logger.info "[Scheduler] Finished queuing all sites."
  end

rescue => e
  Rails.logger.error "[Scheduler] CRITICAL ERROR: #{e.message}"
  Rails.logger.error e.backtrace.first(5).join("\n")
end
