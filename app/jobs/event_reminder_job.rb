class EventReminderJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    return if event.start_date.nil? || event.start_date > 1.day.from_now

    event.bookmarked_by_users.each do |user|
      EventNotificationMailer.event_reminder(user, event).deliver_later
    end
  end
end
