class Users::LoginsController < Users::ApplicationController
skip_before_action :users_only

  def new
    user = User.new
    render :new, locals: {user: user}
  end

  def create
    email = user_params[:email]
    ip_address = request.remote_ip
    # the participant might already exist in our db or possimagic_link_url = participants_session_auth_url(token: participant.login_token)bly a new participant
    user = User.find_by(email: email)

    if user
      # create a signed expiring Rails Global ID - this makes LONG tokens, but browswers can handle it
      # all browsers should handle up to 2000 characters.
      # https://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url-in-different-browsers
      # https://www.geeksforgeeks.org/maximum-length-of-a-url-in-different-browsers/
      global_id = user.to_sgid(expires_in: 1.hour, for: 'user_access')
      access_url = users_session_create_url(token: global_id.to_s)
      LoginMailer.send_link(user, access_url).deliver_later
    else
      # if user isn't found then grab a user and compute the global_id and url (but don't send an email)
      # in order to make the time of both paths similar - so people can't find user emails checking the response times
      # see: https://abevoelker.com/skipping-the-database-with-stateless-tokens-a-hidden-rails-gem-and-a-useful-web-technique/

      global_id = User.first.to_sgid(expires_in: 1.hour, for: 'user_access')
      access_url = user_auth_url(token: global_id.to_s)
    end

    # uncomment to add noise to further make email fishing difficult to time
    # mini_wait = Random.new.rand(10..20) / 1000
    # wait(mini_wait)

    # true or not we state we have sent an access link and redirect to the landing page
    # also prevent email fishing by always returning the same answer
    redirect_to(landing_path, notice: "Access-Link has been sent")
  end

  private

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email)
    end
end
