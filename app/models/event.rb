class Event < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user
  after_create :schedule_reminder

  # 添付ファイル
  has_one_attached :thumbnail
  has_one_attached :image_1
  has_one_attached :image_2

  AREA_OPTIONS = %i[shibuya harajuku aoyama hiroo shoto ikejiri ebisu daikanyama nakameguro omotesando].freeze
  CATEGORY_OPTIONS = %i[gourmet shopping experience exhibition onsen subculture sightseeing].freeze  

  # バリデーション
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :catchphrase, presence: true, length: { maximum: 25 }
  validates :body, presence: true, length: { minimum: 10, maximum: 10_000 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validates :area, presence: true, inclusion: { in: AREA_OPTIONS.map(&:to_s), message: 'は指定された地域から選択してください' }
  validates :place, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORY_OPTIONS.map(&:to_s), message: 'は指定されたカテゴリから選択してください' }
  validates :contact, format: { with: /\A\d{10,11}\z/, message: 'は10〜11桁の数字で入力してください' }, allow_blank: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'は有効なURLを入力してください' },
                   allow_blank: true

  # 添付ファイルのバリデーション
  validates :thumbnail,
            content_type: { in: %w[image/png image/jpg image/jpeg], message: 'はPNG、JPG形式の画像を指定してください' },
            size: { less_than: 5.megabytes, message: 'は5MB以下のファイルにしてください' }

  validates :image_1,
            content_type: { in: %w[image/png image/jpg image/jpeg], message: 'はPNG、JPG形式の画像を指定してください' },
            size: { less_than: 5.megabytes, message: 'は5MB以下のファイルにしてください' }

  validates :image_2,
            content_type: { in: %w[image/png image/jpg image/jpeg], message: 'はPNG、JPG形式の画像を指定してください' },
            size: { less_than: 5.megabytes, message: 'は5MB以下のファイルにしてください' }

  # Ransack関連
  def self.ransackable_attributes(_auth_object = nil)
    column_names
  end

  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:combined_search]
  end

  def self.combined_search(query)
    where(
      'title LIKE :query OR catchphrase LIKE :query OR body LIKE :query OR start_date LIKE :query OR end_date LIKE :query OR area LIKE :query OR place LIKE :query OR station LIKE :query OR category LIKE :query OR contact LIKE :query OR cost LIKE :query OR link LIKE :query',
      query: "%#{query}%"
    )
  end

  # カスタムバリデーション
  def end_date_after_start_date
    return unless start_date.present? && end_date.present? && end_date < start_date

    errors.add(:end_date, 'は開始日より後の日付を入力してください')
  end

  private

  def schedule_reminder
    reminder_time = start_date - 1.day
    reminder_time = reminder_time.change(hour: 9, min: 0, sec: 0)
    EventReminderJob.set(wait_until: reminder_time).perform_later(id)
  end
end
