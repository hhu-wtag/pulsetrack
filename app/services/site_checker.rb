require "net/http"

class SiteChecker
  attr_reader :monitored_site, :uri

  def initialize(site)
    @monitored_site = site
    @uri = URI.parse(site.url)
  end

  def call
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.open_timeout = 5 # seconds to connect
    http.read_timeout = 10 # seconds to wait for response

    start_time = Time.current

    response = http.request_get(uri.request_uri)

    response_time_ms = ((Time.current - start_time) * 1000.0).to_i

    status_symbol = :up # Default to up
    error_msg = nil

    case response
    when Net::HTTPOK, Net::HTTPRedirection
      status_symbol = :up
    when Net::HTTPClientError, Net::HTTPServerError
      # 400-499 (Client Error) and 500-599 (Server Error) are "down"
      status_symbol = :down
      error_msg = "#{response.code} #{response.message}"
    else
      # Any other response is unexpected
      status_symbol = :error
      error_msg = "Unexpected response: #{response.code}"
    end

    {
      status: status_symbol,
      http_status_code: response.code.to_i,
      response_time_ms: response_time_ms,
      error_message: error_msg
    }

  rescue Net::OpenTimeout, Net::ReadTimeout => e
    {
      status: "timed_out",
      http_status_code: nil,
      response_time_ms: ((Time.current - start_time) * 1000).to_i,
      error_message: e.message
    }
  rescue StandardError => e
    {
      status: "error",
      http_status_code: nil,
      response_time_ms: nil,
      error_message: e.message
    }
  end
end
