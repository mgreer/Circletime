class AdminController < ApplicationController
  before_filter :authenticate_user!
# before_filter :authenticate_user!, :only => [:edit, :update, :destroy]  
  
  # GET /audits
  # GET /audits.json
  def audits
    @audits = Audited::Adapters::ActiveRecord::Audit.all
    Rails.logger.info("---------audits: #{@audits} ")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @audits }
    end
  end
  
end
