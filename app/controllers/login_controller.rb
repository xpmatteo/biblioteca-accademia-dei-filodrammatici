class LoginController < ApplicationController
  EXPECTED_PASSWORD = '9817'
  layout "admin"

  def login
    if request.get?
      session[:original_uri] = params[:original_uri]      
    else
      if EXPECTED_PASSWORD == params[:password]
        session[:authenticated] = true
        flash[:notice] = 'Benvenuto, amministratore'
        redirect_to(session[:original_uri] || {:controller => 'documents'})
        session[:original_uri] = nil
      else
        flash[:notice] = 'Password errata'
      end
    end
  end

  def logout
    session[:authenticated] = nil
    redirect_to params[:original_uri] || {:controller => 'documents'}
  end
end
