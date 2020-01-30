class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale, :notification

  private

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def default_url_options _option = {}
    {locale: I18n.locale}
  end

  def notification
    @notifications = current_user.notifications.all.reverse unless current_user.blank?
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "login_user"
      redirect_to login_path
    end
  end
end
