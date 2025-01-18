class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale
  before_action :set_notifications

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_notifications
    if logged_in?
      @notifications = current_user.event_reminders.order(published_at: :desc).limit(10)
    end
  end
end
