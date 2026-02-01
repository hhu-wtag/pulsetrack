namespace :maintenance do
  desc "Remove old check results from the database"
  task cleanup_results: :environment do
    days = ENV["CHECK_RESULT_CLEANUP_DAYS"]&.to_i || 30
    CheckResults::CleanupService.call(days_ago: days)
  end
end
