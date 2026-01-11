class AverageUptimeJob < ApplicationJob
  include ActionView::RecordIdentifier

  queue_as :default

  def perform(monitored_site)
    average = monitored_site.average_response_time

    puts "Performing average check. Average is: ", average

    target_id = dom_id(monitored_site, :average_response_time)

    puts "Target for average is: ", target_id

    Turbo::StreamsChannel.broadcast_replace_to(
      monitored_site,
      target: target_id,
      partial: "monitored_sites/avg_time",
      locals: { average: average, monitored_site: monitored_site }
    )
  end
end
