module ApplicationHelper
  # helper for highlighting active tabbed links
  def is_active?(controller)
    "active" if params[:controller] == controller
  end
end
