# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  MCE_OPTIONS = {:options => {:theme => 'advanced'}}

  def authorized?
    session[:authenticated]
  end
  helper_method :authorized?

  def check_user_is_admin
    unless authorized?
      redirect_to :controller => 'login', :action => 'login'
    end
  end
end