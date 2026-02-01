require "net/http"
require "json"

module Notifications
  class SlackService
    def self.notify(site)
      webhook_url = Rails.application.credentials.slack_webhook_url

      return unless webhook_url

      message = format_message(site)

      Rails.logger.tagged("Slack") do
        Rails.logger.info "Sending alert for #{site.url}"

        uri = URI(webhook_url)

        response = Net::HTTP.post(uri, {
          text: message
        }.to_json, "Content-Type" => "application/json"
        )

        unless response.is_a?(Net::HTTPSuccess)
          Rails.logger.error "Slack API Error: #{response.body}"
        end
      end

    rescue => e
      Rails.logger.error "[Slack] ERROR sending notification: #{e.message}"
    end

    private

    def self.format_message(site)
      emoji = site.last_status == "up" ? "✅" : "🚨"
      status_text = site.last_status.upcase

      "#{emoji} *[PulseTrack]* Site *#{site.name}* is now *#{status_text}*.\nURL: #{site.url}"
    end
  end
end
