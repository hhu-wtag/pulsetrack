class MonitoredSitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_monitored_sites, only: [ :show, :edit, :update, :destroy ]

  def index
    @monitored_sites = current_team.monitored_sites.order(created_at: :desc)
  end

  def show
    @initial_average = @monitored_site.average_response_time
    @uptime = @monitored_site.uptime
    collection = @monitored_site.check_results.order(created_at: :desc)

    @pagy, @check_results = pagy(:offset, collection)
  end

  def new
    @monitored_site = MonitoredSite.new
  end

  def create
    @monitored_site = current_team.monitored_sites.build(monitored_site_params)
    if @monitored_site.save
      redirect_to monitored_sites_path, notice: "Site has been added for monitoring"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def in_maintenance
    @monitored_site = current_team.monitored_sites.find(params[:id])

    @monitored_site.maintenance! unless @monitored_site.maintenance?

    redirect_to monitored_site_path(params[:id])
  end

  def out_maintenance
    @monitored_site = current_team.monitored_sites.find(params[:id])

    @monitored_site.pending! if @monitored_site.maintenance?

    redirect_to monitored_site_path(params[:id])
  end

  def update
  end

  def destroy
    @monitored_site.destroy

    redirect_to monitored_sites_url, notice: "Site has been deleted from monitoring"
  end

  private

  def set_monitored_sites
    @monitored_site = current_team.monitored_sites.find(params[:id])
  end

  def monitored_site_params
    params.require(:monitored_site).permit(:name, :url, :check_frequency_seconds)
  end
end
