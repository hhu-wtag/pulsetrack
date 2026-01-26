class TeamMembershipsController < ApplicationController
  before_action :set_team
  before_action :is_admin?

  def create
    @user_to_add = User.find_by(email: params[:email])

    if @user_to_add.nil?
      redirect to team_path(@team), alert: "User with email #{params[:email]} not found."

      return
    end

    if @team.users.include?(@user_to_add)
      redirect_to team_path(@team), alert: "User is already a member of the team."

      return
    end

    @membership = @team.team_memberships.new(user: @user_to_add, role: params[:role] || "viewer")

    if @membership.save
      redirect_to team_path(@team), notice: "User added to the team successfully."
    else
      redirect_to team_path(@team), alert: "Failed to add user to the team."
    end
  end

  private

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def is_admin?
    unless current_user.is_admin_of?(@team)
      redirect_to team_path(@team), alert: "You are not authorized to perform this action."
    end
  end
end
