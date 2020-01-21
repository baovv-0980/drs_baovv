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
    @notifications = current_user.notifications.all.reverse
  end
end
