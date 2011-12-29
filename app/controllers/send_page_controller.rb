class SendPageController < ApplicationController
  
  def index
    @virtual_pagers = VirtualPager.find_all_by_code_level(false)
    @error = {}
  end
  
  def send_page
    # validate form
    @error = {}
    @error[:pager] = "<li>Must select a pager</li>".html_safe if params[:virtual_pager_id] == ""
    @error[:message] = "<li>Must enter a message</li>".html_safe if params[:message] == ""
    if @error.size > 0
      flash.now[:error] = "Missing fields, please see below"
      @virtual_pagers = VirtualPager.find(:all, :order => "name")
      render :action => 'index'
      return nil
    end
    
    vp = VirtualPager.find_by_id(params[:virtual_pager_id])
    if vp
      vp.send_page(params[:message]) 
      flash[:notice] = "Page sent"
    else
      flash[:error] = "Error: unable to send page, please try again later"
    end
    redirect_to :action => 'index'
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