class ApplicationController < ActionController::Base
  include ProfilesHelper
  include SessionHelper

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale, :notification

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = exception.message
    redirect_to root_path
  end

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
    @notifications = current_user.notifications.reverse if current_user.present?
  end

end
