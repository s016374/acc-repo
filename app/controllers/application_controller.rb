class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # To set up controllers inherted ApplicationController with user authentication
  before_action :authenticate_user!

  # I18n switch language by user
  before_action :set_locale

  private
  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end
  end
end
