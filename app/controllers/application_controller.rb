class ApplicationController < ActionController::Base
  include ProfilesHelper

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale, :notification

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def default_url_options _option = {}
    {locale: I18n.locale}
  end

  def notification
    @notifications = current_user.notifications.all.reverse if current_user.present?
  end

  def logged_in_user
    redirect_to signin_path unless user_signed_in?
  end
end
