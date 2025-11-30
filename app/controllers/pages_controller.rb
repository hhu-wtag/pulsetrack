class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @notifications = current_user.notifications.order(created_at: :desc)
  end
end
