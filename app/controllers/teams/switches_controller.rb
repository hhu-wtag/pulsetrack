class Teams::SwitchesController < ApplicationController
  def create
    team = current_user.teams.find(params[:team_id])

    session[:team_id] = team.id

    redirect_back_or_to teams_path, notice: "Switched to team #{team.name}."
  end
end
