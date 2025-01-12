# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_notifications

  private

  def set_notifications
    if logged_in?
      @notifications = current_user.event_reminders.order(published_at: :desc).limit(10)
    end
  end
end
