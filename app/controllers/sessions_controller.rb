class SessionsController < ApplicationController
  def new
	
  end

  def create
  	user = User.find_by(name: params[:session][:name])
    url = session[:previous_url] || root_url
	session[:previous_url] = nil
	url = root_path if url.eql?(logout_path)
	if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to url
    else
      flash.now[:error] = '帳號或密碼錯誤！請重新輸入。'
	  render 'new'
    end
	
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
