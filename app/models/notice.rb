class Notice < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :published_at, presence: true
end
