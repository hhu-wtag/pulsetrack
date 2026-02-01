class CheckResult < ApplicationRecord
  belongs_to :monitored_site

  enum :status, { up: 0, down: 1, timed_out: 2, error: 3 }

  validates :status, presence: true

  after_create_commit :broadcast_new_result_to_table
  after_create_commit :broadcast_avg_response_time

  private

  def broadcast_avg_response_time
    AverageUptimeJob.perform_later(monitored_site)
  end

  def broadcast_new_result_to_table
    dom_id = "check_results_body_monitored_site_#{monitored_site.id}"

    Rails.logger.tagged("Hotwire", "Site:#{monitored_site.id}") do
      Rails.logger.info "Broadcasting new result to target: #{dom_id}"

      broadcast_prepend_later_to(
        monitored_site,
        target: dom_id,
        partial: "check_results/check_result"
      )

      if monitored_site.check_results.count == 1
        Rails.logger.info "First result detected. Removing 'no_results_row' for Site:#{monitored_site.id}"

        broadcast_remove_to(
          monitored_site,
          target: [ monitored_site, "no_results_row" ]
        )
      end
    end
  rescue => e
    Rails.logger.error "Broadcast failed for CheckResult #{id}: #{e.message}"
  end
end
