module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Create persistent session
  def remember(user)
    # This creates a remember token & saves the digest into the db
    user.remember

    # place user's remember token and id in cookie
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns currently logged in user
  def current_user

    # if there is a temporary session grab the user
    if (user_id = session[:user_id])
      # if user was found before (from prev call on page) return it; else find user
      @current_user ||= User.find_by(id: user_id)
    
    # else if there is a persistent session, verify cookie info, log in, return user
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # check if cookie credentials are good
      if user && user.authenticated?(cookies[:remember_token])
        # create a session
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user
  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  # Deletes persistent session
  def forget(user)
    # sets digest to nil in db
    user.forget

    # deletes cookie credentials
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


end
