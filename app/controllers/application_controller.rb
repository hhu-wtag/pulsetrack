class ApplicationController < ActionController::Base
  include Pagy::Method
  before_action :authenticate_user!
  helper_method :current_team, :current_membership

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html do
        redirect_back_or_to home_path, alert: "You are not authorized to access this page."
      end
    end
  end

  def current_team
    @current_team ||=
      begin
        team = current_user.teams.find_by(id: session[:team_id]) if session[:team_id]
        team ||= current_user.teams.first
        session[:team_id] = team&.id

        team
      end
  end

  def current_membership
    @current_membership ||= current_user.memberships.find_by(team: current_team)
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, current_team)
  end
end
