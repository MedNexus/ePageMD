class ViewLogsController < ApplicationController
  
  def index
    vp = VirtualPager.find_by_id(params[:id])
    @logs = vp.page_logs
  end
end
