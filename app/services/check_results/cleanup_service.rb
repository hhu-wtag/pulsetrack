module CheckResults
  class CleanupService
    def self.call(days_ago: 30)
      cutoff = days_ago.days.ago

      Rails.logger.tagged("Cleanup") do
        count = CheckResult.where("created_at < ?", cutoff).count

        if count > 0
          Rails.logger.warn "Found #{count} records older than #{days_ago} days. Proceeding to delete..."

          CheckResult.where("created_at < ?", cutoff).in_batches(of: 1000).destroy_all

          Rails.logger.info "Cleanup complete. Deleted #{count} old CheckResult records."
        else
          Rails.logger.info "No CheckResult records older than #{days_ago} days found. No action taken."
        end
      end
    rescue => e
      Rails.logger.error "[Cleanup] ERROR during cleanup: #{e.message}"
    end
  end
end
