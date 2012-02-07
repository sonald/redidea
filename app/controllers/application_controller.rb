class ApplicationController < ActionController::Base
  before_filter :prepare_message
  after_filter :client_info
  protect_from_forgery
  
  protected


  def client_info
    return if current_user.nil? or (params[:controller] == 'devise/sessions')
    browser = request.env['HTTP_USER_AGENT']
    from = request.env['HTTP_REFERER']
    $my_logger.info("user = #{current_user.email}, time = #{Time.now}, from = #{from}, user_agent = #{browser}\n")
  end
    
  # Overwriting the after confirmation redirect path method
  def after_confirmation_path_for(resource_name, resource)
    edit_user_registration_path
  end
  
  private

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS|Android/
    end
  end
  helper_method :mobile_device?

  def prepare_message
    @messages = Message.all
    @message = Message.new
  end

end
