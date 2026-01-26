class ApplicationController < ActionController::Base
  include Pagy::Method
  before_action :authenticate_user!
  helper_method :current_team

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_team
    @current_team ||=
      begin
        team = current_user.teams.find_by(id: session[:team_id]) if session[:team_id]
        team ||= current_user.teams.first
        session[:team_id] = team&.id

        team
      end
  end
end
