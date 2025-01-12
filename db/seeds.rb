# メインのサンプルユーザー
user = User.create!(name:  "Example User",
                    email: "example@railstutorial.org",
                    password:              "foobar",
                    password_confirmation: "foobar",
                    admin:     true,
                    activated: true,
                    activated_at: Time.zone.now)

# 追加のユーザー
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーリストを取得
users = User.all

# サンプルイベント
100.times do
  start_date = Faker::Time.forward(days: 30, period: :morning)
  end_date = Faker::Time.between(from: start_date, to: start_date + 1.day)

  Event.create!(
    title: Faker::Lorem.sentence(word_count: 3)[0..29],
    catchphrase: Faker::Lorem.sentence(word_count: 5)[0..24],
    body: Faker::Lorem.paragraph(sentence_count: 5),
    start_date: start_date,
    end_date: end_date,
    area: Event::AREA_OPTIONS.sample,
    place: Faker::Address.full_address,
    station: Faker::Address.city,
    category: Event::CATEGORY_OPTIONS.sample,
    contact: Faker::PhoneNumber.phone_number.gsub(/\D/, '')[0..10],
    cost: Faker::Commerce.price(range: 0..1000.0),
    link: Faker::Internet.url,
    user_id: users.sample.id,
    thumbnail: nil,
    image_1: nil,
    image_2: nil
  )
end

# サンプルイベント(cost:0)
10.times do
  start_date = Faker::Time.forward(days: 30, period: :morning)
  end_date = Faker::Time.between(from: start_date, to: start_date + 1.day)

  Event.create!(
    title: Faker::Lorem.sentence(word_count: 3)[0..29],
    catchphrase: Faker::Lorem.sentence(word_count: 5)[0..24],
    body: Faker::Lorem.paragraph(sentence_count: 5),
    start_date: start_date,
    end_date: end_date,
    area: Event::AREA_OPTIONS.sample,
    place: Faker::Address.full_address,
    station: Faker::Address.city,
    category: Event::CATEGORY_OPTIONS.sample,
    contact: Faker::PhoneNumber.phone_number.gsub(/\D/, '')[0..10],
    cost: 0,
    link: Faker::Internet.url,
    user_id: users.sample.id,
    thumbnail: nil,
    image_1: nil,
    image_2: nil
  )
end

# 各ユーザーがランダムにイベントをブックマーク
events = Event.all
User.find_each do |user|
  rand(1..5).times do
    event = events.sample
    Bookmark.find_or_create_by!(user_id: user.id, event_id: event.id)
  end
end

# お知らせのサンプルデータ
10.times do |n|
  Notice.create!(
    title: "#{n + 1}のお知らせ",
    body: "これはお知らせの内容です。詳細情報がここに入ります。",
    published_at: Faker::Time.backward(days: 30, period: :evening)
  )
end

# メインユーザーのサンプルリマインダー
user = User.find_by(email: "example@railstutorial.org")
events = Event.all

10.times do
  event = events.sample
  EventReminder.create!(
    user_id: user.id,
    event_id: event.id,
    title: "#{event.title}の通知",
    body: "#{event.title}が#{event.start_date.strftime('%Y年%m月%d日 %H:%M')}に開催されます。",
    published_at: Faker::Time.backward(days: 10, period: :evening)
  )
end
