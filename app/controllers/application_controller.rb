class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user

  before_filter :inject_delay if Rails.env.development?

  def login_user(user)
    session[:user_id] = user.id
  end

  def logout_user
    session.delete(:user_id)
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(:id => session[:user_id])
  end

  def alert(message, style='info')
    flash[:notice] = message
    flash[:style] = style
  end

  def validation_error_message(record)
    messages = record.errors.messages.map { |attribute, messages| messages.first }
    messages.first
  end

  def inject_delay
    sleep 1
  end
end
