module ApplicationHelper
  # helper for highlighting active tabbed links
  def is_active?(controller)
    "active" if params[:controller] == controller
  end
  
  # helper for displaying form error messages
  def display_errors(errors)
    str = "".html_safe  
    str += "<div id='errorMsgDiv'>Please correct the following errors:<br/>".html_safe if errors.full_messages.size > 0
    errors.full_messages.each do |msg|
      str += "<li>#{msg}</li>".html_safe
    end
    str += "</div>".html_safe if errors.full_messages.size > 0
  end
  
end
