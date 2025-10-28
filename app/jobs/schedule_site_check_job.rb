class ScheduleSiteCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sites_due = MonitoredSite.where("next_check_at <= ?", 1.minutes.ago)

    puts sites_due.inspect

    sites_due.each do |site|
      MonitorSiteJob.perform_later(site)

      site.update_column(
        :next_check_at,
        Time.current + site.check_frequency_seconds.seconds
      )
    end
  end
end
