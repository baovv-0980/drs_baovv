class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def default_url_options _option = {}
    {locale: I18n.locale}
  end
end
