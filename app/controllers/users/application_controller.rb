class Users::ApplicationController < ApplicationController
  before_action :users_only

  def current_user
    # `dig` and `find_by` avoid raising an exception w/o a session
    user_id = session.dig(:user_id)
    @current_user ||= User.find_by(id: user_id)
  end

  private

    # code to ensure only logged in users have access to users pages
    def users_only
      # send person to a safe page if not logged in
      if current_user.blank?
        # send to login page to get an access link
        redirect_back(fallback_location: landing_path,
                      :alert => "Login Required")
        # once the below page is created we can redirect to here instead
        # redirect_back(fallback_location: new_users_login_path,
        #               :alert => "Login Required")
      end
    end
end
