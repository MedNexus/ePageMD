class SignOntoPagerController < ApplicationController
  
  def index
   @sign_on_off = SignOntoPager.new
  end
  
  def multiple
    unless params[:pager_number]
      @sign_onoff_multiple = SignOnoffMultiple.new
      render :template => "sign_onto_pager/multiple_pager_number"
      return false
    end
    
    @sign_onoff_multiple = SignOnoffMultiple.new(:pager_number => params[:pager_number])
    unless @sign_onoff_multiple.valid?
      flash.now[:error] = "Must provide valid pager number"
      render :template => "sign_onto_pager/multiple_pager_number"
      return false
    end
  end
  
  def process_multiple
    @sign_onoff_multiple = SignOnoffMultiple.new(:pager_number => params[:pager_number], :virtual_pagers => params[:virtual_pager_id])
    unless @sign_onoff_multiple.valid?
      flash.now[:error] = "Must provide valid pager number"
      render :template => "sign_onto_pager/multiple_pager_number"
      return false
    end

    if @sign_onoff_multiple.update
      # return list of signed on pagers
      pagr_str = @sign_onoff_multiple.list_signed_on.collect{|x| x.name}.join(", ")
      if pagr_str == ""
        flash[:notice] = "You have been signed off all pagers"
      else
        flash[:notice] = "You are covering: " + pagr_str
      end
      redirect_to :action => "index"
    else
      flash[:error] = "Unable to update virtual pagers"
      redirect_to :action => "multiple", :pager_number => @sign_onoff_multiple.pager_number
    end
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