class Event < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  # 添付ファイル
  has_one_attached :thumbnail
  has_many_attached :images

  # バリデーション
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :catchphrase, presence: true, length: { maximum: 25 }
  validates :body, presence: true, length: { minimum: 10, maximum: 10000 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validates :area, presence: true
  validates :place, presence: true
  validates :category, presence: true
  validates :contact, format: { with: /\A\d{10,11}\z/, message: "は10〜11桁の数字で入力してください" }, allow_blank: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "は有効なURLを入力してください" }, allow_blank: true

  # 添付ファイルのバリデーション
  validates :thumbnail,
            content_type: { in: %w[image/png image/jpg image/jpeg], message: 'はPNG、JPG形式の画像を指定してください' },
            size: { less_than: 5.megabytes, message: 'は5MB以下のファイルにしてください' }

  validates :images,
            content_type: { in: %w[image/png image/jpg image/jpeg], message: 'はPNG、JPG形式の画像を指定してください' },
            size: { less_than: 5.megabytes, message: 'は5MB以下のファイルにしてください' }

  # Ransack関連
  def self.ransackable_attributes(auth_object = nil)
    column_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_scopes(auth_object = nil)
    [:combined_search]
  end

  def self.combined_search(query)
    where(
      "title LIKE :query OR catchphrase LIKE :query OR body LIKE :query OR start_date LIKE :query OR end_date LIKE :query OR area LIKE :query OR place LIKE :query OR station LIKE :query OR category LIKE :query OR contact LIKE :query OR cost LIKE :query OR link LIKE :query",
      query: "%#{query}%"
    )
  end

  # カスタムバリデーション
  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "は開始日より後の日付を入力してください")
    end
  end
end
