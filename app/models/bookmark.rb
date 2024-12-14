class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :event_id, uniqueness: { scope: :user_id, message: "は既にブックマークされています。" }
end
