class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?

  def login_user(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(:id => session[:user_id])
  end

  def alert(message)
    flash[:notice] = message
  end
end
