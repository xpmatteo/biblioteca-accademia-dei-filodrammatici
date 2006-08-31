class LoginController < ApplicationController
  EXPECTED_PASSWORD = '9817'

  def login
    if request.post?
      if EXPECTED_PASSWORD == params[:password]
        redirect_to :controller => 'news'
        session[:authenticated] = true
        flash[:notice] = 'Benvenuto, amministratore'
      else
        flash[:notice] = 'Password errata'
      end
    end
  end

  def logout
    session[:authenticated] = nil
    redirect_to :controller => 'news'
  end
end
