module ApplicationHelper
  def active_nav_button_class(path)
    if request.path.start_with?(path)
      ""
    else
      "btn-ghost"
    end
  end

  def role_badge_class(role)
    case role
    when "admin" then "badge-primary"
    when "editor" then "badge-secondary"
    else "badge-ghost"
    end
  end
end
