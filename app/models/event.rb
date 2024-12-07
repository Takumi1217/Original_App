class Event < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  
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
end

# カスタムバリデーション
def end_date_after_start_date
  if start_date.present? && end_date.present? && end_date < start_date
    errors.add(:end_date, "は開始日より後の日付を入力してください")
  end
end
