class MonitoredSitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_monitored_sites, only: [:show, :edit, :update, :destroy]

  def index
    @monitored_sites = current_user.monitored_sites.order(created_at: :desc)
  end

  def show
    @check_results = @monitored_site.check_results.order(created_at: :desc).limit(50)
  end

  def new
    @monitored_site = MonitoredSite.new
  end

  def create
    @monitored_site = current_user.monitored_sites.build(monitored_site_params)
    if @monitored_site.save
      redirect_to monitored_sites_path, notice: "Site has been added for monitoring"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @monitored_site.destroy

    redirect_to monitored_sites_url, notice: "Site has been deleted from monitoring"
  end

  private

  def set_monitored_sites
    @monitored_site = current_user.monitored_sites.find(params[:id])
  end

  def monitored_site_params
    params.require(:monitored_site).permit(:name, :url, :check_frequency_seconds)
  end
end
