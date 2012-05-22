class WorkUnitsController < ApplicationController
  # GET /work_units
  # GET /work_units.json
  def index
    @work_units = WorkUnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @work_units }
    end
  end

  # GET /work_units/1
  # GET /work_units/1.json
  def show
    @work_unit = WorkUnit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @work_unit }
    end
  end

  # GET /work_units/new
  # GET /work_units/new.json
  def new
    @work_unit = WorkUnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @work_unit }
    end
  end

  # GET /work_units/1/edit
  def edit
    @work_unit = WorkUnit.find(params[:id])
  end

  # POST /work_units
  # POST /work_units.json
  def create
    @work_unit = WorkUnit.new(params[:work_unit])

    respond_to do |format|
      if @work_unit.save
        format.html { redirect_to @work_unit, :notice => 'Work unit was successfully created.' }
        format.json { render :json => @work_unit, :status => :created, :location => @work_unit }
      else
        format.html { render :action => "new" }
        format.json { render :json => @work_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /work_units/1
  # PUT /work_units/1.json
  def update
    @work_unit = WorkUnit.find(params[:id])

    respond_to do |format|
      if @work_unit.update_attributes(params[:work_unit])
        format.html { redirect_to @work_unit, :notice => 'Work unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @work_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /work_units/1
  # DELETE /work_units/1.json
  def destroy
    @work_unit = WorkUnit.find(params[:id])
    @work_unit.destroy

    respond_to do |format|
      format.html { redirect_to work_units_url }
      format.json { head :no_content }
    end
  end
end
