class CheckResult < ApplicationRecord
  belongs_to :monitored_site

  enum :status, { up: 0, down: 1, timed_out: 2, error: 3 }

  validates :status, presence: true

  after_create_commit :broadcast_new_result_to_table

  private

  def broadcast_new_result_to_table
    domId = "check_results_body_monitored_site_#{monitored_site.id}"

    puts "after check_result created! -> ", domId

    broadcast_prepend_later_to monitored_site,
                               target: domId,
                               partial: "check_results/check_result"

    if monitored_site.check_results.length == 1
      broadcast_remove_to monitored_site,
                          target: [ monitored_site, "no_results_row" ]
    end
  end
end
