class Event < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  # バリデーション
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 } # 必須かつ最大30文字
  validates :catchphrase, presence: true, length: { maximum: 25 } # 必須かつ最大25文字
  validates :body, presence: true, length: { minimum: 10, maximum: 10000 } # 必須かつ最小10文字
  validates :start_date, presence: true # 開始日は必須
  validates :end_date, presence: true # 終了日も必須
  validate :end_date_after_start_date # 終了日が開始日より後であることをカスタムバリデーションで確認
  validates :area, presence: true # 地域は必須
  validates :place, presence: true # 場所は必須
  validates :category, presence: true # カテゴリは必須
  validates :contact, format: { with: /\A\d{10,11}\z/, message: "は10〜11桁の数字で入力してください" }, allow_blank: true # 電話番号のフォーマット
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true # 必須かつ料金は0以上の数値
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "は有効なURLを入力してください" }, allow_blank: true # URLのフォーマット

  # 全てのカラムをransackで検索可能にする
  def self.ransackable_attributes(auth_object = nil)
    column_names # Eventモデルの全てのカラムを取得して返す
  end

  # Ransackで検索可能な関連を指定
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  # 必要に応じてRansack用スコープを追加
  def self.ransackable_scopes(auth_object = nil)
    [:combined_search]
  end

  # 検索スコープ
  def self.combined_search(query)
    where(
      "title LIKE :query OR catchphrase LIKE :query OR body LIKE :query OR start_date LIKE :query OR end_date LIKE :query OR area LIKE :query OR place LIKE :query OR station LIKE :query OR category LIKE :query OR contact LIKE :query OR cost LIKE :query OR link LIKE :query",
      query: "%#{query}%"
    )
  end
  
end

# カスタムバリデーション
def end_date_after_start_date
  if start_date.present? && end_date.present? && end_date < start_date
    errors.add(:end_date, "は開始日より後の日付を入力してください")
  end
end
