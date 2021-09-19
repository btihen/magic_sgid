class Users::SessionsController < Users::ApplicationController
  # before_action :users_only, only: :destroy
  skip_before_action :users_only, only: :create

  def create
    sgid_token = params[:token].to_s
    user = GlobalID::Locator.locate_signed(sgid_token, for: 'user_access')
    if user
      # create the session id for current_user to access
      session[:user_id] = user.id
      redirect_to(users_home_path, notice: "Welcome back #{user.name}")
    else
      flash[:alert] = 'Oops - you need a new login link'
      redirect_to(landing_path)
      # later when created we will redirect to login access link page
      # redirect_to(new_users_login)
    end
  end

  # allow a user to logout / destroy session if desired
  def destroy
    user = current_user
    if user
      session[:user_id] = nil
      flash[:notice] = "logout successful"
    else
      falsh[:alert] = "Oops, there was a problem"
    end
    redirect_to(landing_path)
  end

end
