class SendPageController < ApplicationController
  
  def index
    @virtual_pagers = VirtualPager.find(:all, :order => "name")
  end
  
  def send_page
    # validate form
    flash[:error] = "".html_safe
    flash[:error] += "<li>Must select a pager</li>".html_safe if params[:virtual_pager_id] == ""
    flash[:error] += "<li>Must enter a message</li>".html_safe if params[:message] == ""
    if flash[:error] != ""
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