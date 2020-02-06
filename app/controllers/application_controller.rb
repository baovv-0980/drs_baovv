class ApplicationController < ActionController::Base
  include SessionsHelper
  include ProfilesHelper

  before_action :set_locale, :notification

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
    redirect_to login_path unless logged_in?
  end
end
