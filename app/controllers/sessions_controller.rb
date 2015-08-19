class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: :new
  def new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user.nil?
      render :new
    else
      @user.reset_session_token!
      log_in(@user)
      # session[:token] = @user.session_token
      redirect_to cats_url
    end
  end

  def destroy
    log_out
    redirect_to new_session_url
  end


end
