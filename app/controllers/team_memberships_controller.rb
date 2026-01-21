class TeamMembershipsController < ApplicationController
  before_action :set_team
  before_action :is_admin?

  def create
    user = User.find_by!(email: params[:email])

    role = params[:role] || "viewer"

    if not user
      redirect_to team_team_membership_path(@team), alert: "User with email #{params[:email]} not found."

      return
    end

    membership = @team.team_memberships.find_or_initialize_by(user: user)
    membership.role = params[:role] || "viewer"

    if membership.save
      redirect_to team_team_memberships_path(@team), notice: "#{user.email} has been added to the team as #{membership.role}."
    else
      redirect_to team_team_memberships_path(@team), alert: "Failed to add user to the team."
    end
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def is_admin?
    unless current_user.is_admin_of?(@team)
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
