class CleanupCheckResultsJob < ApplicationJob
  queue_as :default

  def perform(*)
    CheckResults::CleanupService.call(days_ago: 30)
  end
end
