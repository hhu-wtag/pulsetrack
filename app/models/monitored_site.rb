class MonitoredSite < ApplicationRecord
  belongs_to :user
  has_many :check_results, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_commit :handle_status_change, on: :update, if: :saved_change_to_last_status?

  enum :last_status, { pending: 0, up: 1, down: 2 }

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

  def handle_status_change
    previous_status, current_status = saved_change_to_last_status

    puts "Status changed from #{previous_status} to #{current_status} for site #{self.id}"

    if (previous_status == "up" || previous_status == "pending") && current_status == "down"
      self.notifications.create!(
        user: self.user,
        message: "Site down: #{self.name} is unreachable at #{self.url}."
      )

      # TODO: send email notification to user

    elsif previous_status == "down" && current_status == "up"
      self.notifications.create!(
        user: self.user,
        message: "Site up: #{self.name} is back online!"
      )

      # TODO: send email notification to user
    end
  end
end
