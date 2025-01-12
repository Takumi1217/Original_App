class EventReminder < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :title, presence: true
  validates :body, presence: true
  validates :published_at, presence: true
end
