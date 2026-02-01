class TeamsController < ApplicationController
  before_action :set_team, only: [ :show, :update ]
  before_action :ensure_admin!, only: [ :update ]

  def index
    @teams = current_user.teams.includes(:team_memberships)
  end

  def show
    @monitored_sites = @team.monitored_sites
    @memberships = @team.team_memberships.includes(:user)
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.team_memberships.build(user: current_user, role: :admin)

    if @team.save
      redirect_to teams_path, notice: "Team: #{@team.name} created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = current_user.teams.find(params[:id])
  end

  def ensure_admin!
    redirect_to @team, alert: "Admins only." unless current_user.is_admin_of?(@team)
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
