class SendPageController < ApplicationController
  
  def index
    @routine_page = RoutinePage.new
  end
  
  def send_page
    @routine_page = RoutinePage.new(params[:routine_page])
    if @routine_page.valid?
      if @routine_page.send_page
        flash[:notice] = "Page Sent!"
        redirect_to :action => 'index'
      else
        flash.now[:error] = "ERROR: unable to page an MD"
        render :action => 'index'
      end
    else
      render :action => 'index'
    end
  end

  # controller specifically designed for rapid code blue / rapid response notifications
  def code
    @code_page = CodePage.new
  end
  
  def send_code
    @code_page = CodePage.new(params[:code_page])
    if @code_page.valid?
      # blast away!
      if @code_page.send_page
        flash[:notice] = "Page Sent!"
        redirect_to :action => 'code'
      else
        flash.now[:error] = "Notification FAILED, please use backup notification"
        render :action => 'code'
      end
    else
      render :action => 'code'
    end
  end
  
end