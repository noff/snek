class ApplicationController < ActionController::Base

  before_action :set_locale

  def set_locale
    locale = 'en'
    if locale_valid?(params[:locale])
      locale = params[:locale]
    else
      if cookies[:locale] && locale_valid?(params[:locale])
        locale = cookies[:locale]
      else
        begin
          try_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
          if locale_valid?(try_locale)
            locale = try_locale
          end
        rescue
        end
      end
    end
    cookies[:locale] = { value: locale, expires: 1.year.from_now, path: '/', domain: Rails.env.development? ? request.host : ".#{request.domain}" }
    I18n.locale = locale
  end


  private

  def locale_valid?(locale)
    locale.present? && %w(ru en).inclide?(locale)
  end

end
