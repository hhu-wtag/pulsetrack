class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @monitored_sites = current_user.monitored_sites.order(created_at: :desc)
    @sites_count = current_user.monitored_sites.unscope(:order).group("last_status").count
    @recent_results = CheckResult.where(monitored_site: @monitored_sites).order(created_at: :desc).limit(50)
  end
end
