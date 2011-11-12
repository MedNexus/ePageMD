class ViewLogsController < ApplicationController
  
  def index
    begin
      vp = VirtualPager.find_by_id(params[:id])
      @logs = vp.page_logs
    rescue
      redirect_to :controller => "virtual_pagers", :flash => {:error => "could not find virtual pager"}
    end
  end
end
