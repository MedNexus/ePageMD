class SendPageController < ApplicationController
  
  def index
    @virtual_pagers = VirtualPager.find(:all, :order => "name")
    @error = {}
  end
  
  def send_page
    # validate form
    @error = {}
    @error[:pager] = "<li>Must select a pager</li>".html_safe if params[:virtual_pager_id] == ""
    @error[:message] = "<li>Must enter a message</li>".html_safe if params[:message] == ""
    if @error.size > 0
      flash[:error] = "Missing fields, please see below"
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
  
end