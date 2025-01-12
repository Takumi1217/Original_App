class EventNotificationMailer < ApplicationMailer
  def event_reminder(user, event)
    @user = user
    @event = event
    mail(to: @user.email, subject: "#{@event.title}の1日前のお知らせ")

    EventReminder.create(
      user: @user,
      event: @event,
      title: "#{@event.title}の1日前のお知らせ",
      body: "#{@event.title}が明日開催されます。お見逃しなく！",
      published_at: Time.current
    )
  end
end
