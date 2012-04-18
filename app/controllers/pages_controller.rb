class PagesController < ApplicationController

  def home
    if current_user
      redirect_to dashboard_path()
    else
      @user = User.new
    end

  end

  def support_submit

    @support = FauxModel::CustomerSupport.new params[:faux_model_customer_support]
    SupportMailer.customer_support(@support)
    render :template => '/errors/support_thanks'
    
  end


  def contact
    
  end
  
  def about
    
  end
  
  def help
    
  end

	def terms

	end

	def privacy
		
	end

	def faq
		
	end

end
