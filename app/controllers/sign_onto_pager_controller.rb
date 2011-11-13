class SignOntoPagerController < ApplicationController
  
  def index
    @virtual_pagers = VirtualPager.find(:all, :order => "name")
  end
  
  def multiple
  end
  
  def add_pager
    # validate form first
    flash[:error] = "".html_safe
    flash[:error] += "Must select a valid pager id <br/>".html_safe if params[:virtual_pager_id] == nil
    flash[:error] += "Must enter a pager number <br/>".html_safe if params[:pager_number] == ""
    flash[:error] += "Must select either sign on or sign off <br/>".html_safe if params[:sign_on_off] == nil
    if flash[:error] != ""
      redirect_to :action => 'index' 
      return nil
    end
    
    vp = VirtualPager.find_by_id(params[:virtual_pager_id])
    if params[:sign_on_off] == 'ON'
      if vp.add_pager(params[:pager_number])
        flash[:notice] = "Added pager #{params[:pager_number]} to #{vp.name}"
      else
        flash[:error] = "Invalid pager number, or pager already signed onto this virtual pager"
      end
    end
    
    if params[:sign_on_off] == 'OFF'
      if vp.remove_pager(params[:pager_number])
        flash[:notice] = "Removed pager #{params[:pager_number]} from #{vp.name}"
      else
        flash[:error] = "Unable to remove pager #{params[:pager_number]}, are you sure it was signed on?"
      end
    end
    
    render :action => 'index'
  end
  
end