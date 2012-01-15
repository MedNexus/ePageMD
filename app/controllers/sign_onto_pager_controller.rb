class SignOntoPagerController < ApplicationController
  
  def index
   @sign_on_off = SignOntoPager.new
  end
  
  def multiple
  end
  
  def add_pager
    @sign_on_off = SignOntoPager.new(params[:sign_onto_pager])
    if @sign_on_off.valid?
      if @sign_on_off.process
        flash[:notice] = "#{@sign_on_off.pager_number} Signed #{@sign_on_off.sign_on_off} pager"
        redirect_to :action => "index"
      else
        flash.now[:error] = "ERROR: unable to sign on/off pager"
        render :action => 'index'
      end
    else
      render :action => 'index'
    end
  end
  
end