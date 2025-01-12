class EventRemindersController < ApplicationController
  before_action :logged_in_user

  def index
    @event_reminders = current_user.event_reminders.order(published_at: :desc).limit(10)
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end
end
