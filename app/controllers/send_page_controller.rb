class SendPageController < ApplicationController
  
  def index
    @virtual_pagers = VirtualPager.find(:all, :order => "name")
  end
  
  def send_page
    # validate form
    flash[:error] = "".html_safe
    flash[:error] += "Must select a pager<br/>".html_safe if params[:virtual_pager_id] == ""
    flash[:error] += "Must enter a message<br/>".html_safe if params[:message][:body] == ""
    if flash[:error] != ""
      redirect_to :action => 'index' 
      return nil
    end
    
    vp = VirtualPager.find_by_id(params[:virtual_pager_id])
    vp.send_page(params[:message][:body]) if vp
    redirect_to :action => 'index'
  end
  
end