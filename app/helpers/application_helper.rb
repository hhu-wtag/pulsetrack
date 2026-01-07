module ApplicationHelper
  def active_nav_button_class(path)
    if request.path.start_with?(path)
      ""
    else
      "btn-ghost"
    end
  end
end
