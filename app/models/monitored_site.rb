class MonitoredSite < ApplicationRecord
  belongs_to :team
  has_many :check_results, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_commit :handle_status_change, on: :update, if: :saved_change_to_last_status?

  enum :last_status, { pending: 0, up: 1, down: 2, maintenance: 3 }

  scope :ready_for_check, -> {
    where("next_check_at <= ?", Time.current)
      .where.not(last_status: :maintenance)
  }

  validates :name, presence: true
  validates :url, presence: true, url: {
    schemes: %w[http https],
    no_local: true
  }

  def average_response_time(within: 1.hour)
    check_results
      .where(created_at: within.ago..Time.current)
      .average(:response_time_ms)
  end

  def uptime(within: 1.hour)
    results = check_results
                .where(created_at: within.ago..Time.current)

    total_count = results.count

    return "N/A" if total_count.zero?

    up_count = results.up.count

    ((up_count.to_f / total_count) * 100).round(2)
  end

  private

  def broadcast_to_dashboard
    latest_result = check_results.last

    return if latest_result.nil?

    broadcast_prepend_to(
      "monitoring_dashboard",
      target: "global_live_feed",
      partial: "check_results/check_result_live_feed",
      locals: { check_result: latest_result }
    )
  end

  def handle_status_change
    previous_status, current_status = saved_change_to_last_status

    return if previous_status == current_status

    Rails.logger.tagged("StatusChange", "SiteID: #{id}") do
      severity = current_status == "down" ? :warn : :info
      Rails.logger.send(severity, "Transition: #{previous_status || 'nil'} -> #{current_status} (#{url})")

      broadcast_to_dashboard

      if (previous_status == "up" || previous_status == "pending") && current_status == "down"
        Rails.logger.warn "ALERT: Site went DOWN. Creating notification record."

        notifications.create!(
          user: user,
          message: "Site down: #{name} is unreachable at #{url}."
        )

        Rails.logger.debug "Email Notification: [PENDING IMPLEMENTATION] for Site:#{id}"

      elsif previous_status == "down" && current_status == "up"
        Rails.logger.info "RECOVERY: Site is back UP. Creating notification record."

        notifications.create!(
          user: user,
          message: "Site up: #{name} is back online!"
        )

        Rails.logger.debug "Email Notification: [PENDING IMPLEMENTATION] for Site:#{id}"
      end
    end
  rescue => e
    Rails.logger.error "FAILED to handle status change for Site #{id}: #{e.message}"
  end
end
