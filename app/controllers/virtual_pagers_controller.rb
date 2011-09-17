class VirtualPagersController < ApplicationController
  # GET /virtual_pagers
  # GET /virtual_pagers.json
  def index
    @virtual_pagers = VirtualPager.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @virtual_pagers }
    end
  end

  # GET /virtual_pagers/1
  # GET /virtual_pagers/1.json
  def show
    @virtual_pager = VirtualPager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @virtual_pager }
    end
  end

  # GET /virtual_pagers/new
  # GET /virtual_pagers/new.json
  def new
    @virtual_pager = VirtualPager.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @virtual_pager }
    end
  end

  # GET /virtual_pagers/1/edit
  def edit
    @virtual_pager = VirtualPager.find(params[:id])
  end

  # POST /virtual_pagers
  # POST /virtual_pagers.json
  def create
    @virtual_pager = VirtualPager.new(params[:virtual_pager])

    respond_to do |format|
      if @virtual_pager.save
        format.html { redirect_to :action => 'index', :notice => 'Virtual pager was successfully created.' }
        format.json { render :json => @virtual_pager, :status => :created, :location => @virtual_pager }
      else
        format.html { render :action => "new" }
        format.json { render :json => @virtual_pager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /virtual_pagers/1
  # PUT /virtual_pagers/1.json
  def update
    @virtual_pager = VirtualPager.find(params[:id])

    respond_to do |format|
      if @virtual_pager.update_attributes(params[:virtual_pager])
        format.html { redirect_to :action => 'index', :notice => 'Virtual pager was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @virtual_pager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /virtual_pagers/1
  # DELETE /virtual_pagers/1.json
  def destroy
    @virtual_pager = VirtualPager.find(params[:id])
    @virtual_pager.destroy

    respond_to do |format|
      format.html { redirect_to virtual_pagers_url }
      format.json { head :ok }
    end
  end
end
