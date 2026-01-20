class Teams::SwitchesController < ApplicationController
  def create
    team = current_user.teams.find(params[:id])

    session[:team_id] = team.id

    redirect_back_or_to root_path
  end
end
