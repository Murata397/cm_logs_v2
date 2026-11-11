puts "サンプルデータを作成中..."

SEED_IMAGE_DIR = Rails.root.join("db/seeds/images")

# 写真ファイルがあれば添付する（なければ何もしない）
def attach_seed_image(record, attachment_name, filename)
  return if filename.blank?

  path = SEED_IMAGE_DIR.join(filename)
  return unless File.exist?(path)
  return if record.public_send(attachment_name).attached?

  record.public_send(attachment_name).attach(io: File.open(path), filename: filename)
end

demo = User.find_or_create_by!(email: "demo@example.com") do |u|
  u.name = "整備好きのリク"
  u.password = "password"
end

car = demo.cars.find_or_create_by!(car_name: "プリウス") do |c|
  c.manufacturer_name = "トヨタ"
  c.car_model = "ZVW30"
  c.odometer = 120_000
  c.purpose = "通勤"
end
attach_seed_image(car, :image, "prius.jpg")

samples = [
  { title: "エンジンオイル交換（DIY）", image: "oil.jpg", category: "メンテナンス", difficulty: :normal, minutes: 30, cost: 3000,
    summary: "5,000kmごとのオイル交換を自分でやってみました。",
    steps: ["ジャッキアップして車体を固定する", "ドレンボルトを外して古いオイルを抜く", "オイルフィルターを交換する", "新しいオイルを入れて量を確認する"],
    tools: ["ジャッキ", "ラチェットレンチ", "オイルジョッキ", "フィルターレンチ"] },
  { title: "スタッドレスタイヤへ交換", image: "tire.jpg", category: "メンテナンス", difficulty: :easy, minutes: 60, cost: 0,
    summary: "冬に向けてタイヤを履き替えました。",
    steps: ["ナットを少しゆるめる", "ジャッキアップする", "タイヤを付け替える", "トルクレンチで締める"],
    tools: ["ジャッキ", "クロスレンチ", "トルクレンチ"] },
  { title: "バッテリー交換", image: "battery.jpg", category: "日常点検", difficulty: :normal, minutes: 40, cost: 15000,
    summary: "エンジンのかかりが悪くなったので交換しました。",
    steps: ["マイナス端子から外す", "固定金具を外してバッテリーを取り出す", "新しいバッテリーを固定する", "プラス端子からつなぐ"],
    tools: ["スパナ", "メモリーバックアップ"] },
  { title: "ワイパーゴム交換", image: "wiper.jpg", category: "日常点検", difficulty: :easy, minutes: 10, cost: 1200,
    summary: "拭きムラが出てきたのでゴムだけ交換。",
    steps: ["ワイパーアームを立てる", "古いゴムを抜く", "新しいゴムを差し込む"],
    tools: [] },
  { title: "エアフィルター交換", image: "air_filter.jpg", category: "メンテナンス", difficulty: :easy, minutes: 15, cost: 2500,
    summary: "工具ほぼなしでできる簡単な整備です。",
    steps: ["エアクリーナーボックスのクリップを外す", "古いフィルターを取り出す", "新しいフィルターを入れて閉じる"],
    tools: ["マイナスドライバー"] },
  { title: "手洗い洗車とコーティング", image: "wash.jpg", category: "洗車", difficulty: :normal, minutes: 120, cost: 4000,
    summary: "週末にじっくり洗車しました。",
    steps: ["水で砂やホコリを流す", "シャンプーで上から洗う", "拭き上げる", "コーティング剤を塗る"],
    tools: ["洗車スポンジ", "マイクロファイバークロス"] }
]

samples.each_with_index do |s, i|
  maintenance = demo.maintenances.find_by(title: s[:title]) ||
    demo.maintenances.create!(
      car: car,
      title: s[:title],
      maintenance_day: Date.current - (i * 7),
      category: s[:category],
      work_difficulty: s[:difficulty],
      work_time_minutes: s[:minutes],
      work_cost: s[:cost],
      summary: s[:summary],
      status: :published,
      steps_attributes: s[:steps].each_with_index.map { |title, n| { position: n + 1, title: title } },
      tools_attributes: s[:tools].map { |name| { name: name } }
    )
  attach_seed_image(maintenance, :images, s[:image])
end

# ゲストユーザーの見本データ（マイページの機能を見てもらうため）
guest = User.guest

guest_car = guest.cars.find_or_create_by!(car_name: "フィット") do |c|
  c.manufacturer_name = "ホンダ"
  c.car_model = "GK3"
  c.odometer = 68_000
  c.purpose = "通勤・買い物"
end
attach_seed_image(guest_car, :image, "fit.jpg")

if guest_car.fuel_logs.empty?
  [
    [70, 412.3, 22.4], [56, 438.9, 23.1], [42, 401.2, 21.8],
    [28, 455.0, 22.9], [14, 470.6, 23.0], [3, 448.1, 21.5]
  ].each do |days_ago, trip, fuel|
    guest_car.fuel_logs.create!(
      refueled_on: Date.current - days_ago,
      trip_distance: trip,
      fuel_amount: fuel,
      fuel_type: "レギュラー"
    )
  end
end

guest_car.inspection_schedules.find_or_create_by!(item: "エンジンオイル交換") do |s|
  s.next_due_on = Date.current + 10
  s.next_due_odometer = 68_400
end
guest_car.inspection_schedules.find_or_create_by!(item: "車検") do |s|
  s.next_due_on = Date.current + 120
end

demo.maintenances.visible.limit(2).each do |m|
  guest.favorites.find_or_create_by!(maintenance: m)
end

# 見本のグループ（demoがオーナー。ゲストはメンバーとして参加済み）
hybrid_group = Group.find_or_create_by!(name: "ハイブリッド車の整備部", owner: demo) do |g|
  g.theme = "ハイブリッド車"
  g.introduction = "プリウス・アクア・フィットなど、ハイブリッド車の整備情報を交換するグループです。"
  g.rules = "作業は安全第一で。高電圧の部分には触らないこと。部品の売買はしません。"
end
hybrid_group.group_users.find_or_create_by!(user: guest) { |gu| gu.status = :approved }
hybrid_group.notices.find_or_create_by!(title: "ようこそ！まずは自己紹介をどうぞ", user: demo) do |n|
  n.body = "参加ありがとうございます。\n乗っている車と、これまでにやった整備を、コメントで教えてください。"
end

Group.find_or_create_by!(name: "洗車・コーティング研究会", owner: demo) do |g|
  g.theme = "洗車"
  g.introduction = "手洗い洗車やコーティングのやり方、おすすめの道具を紹介し合うグループです。"
end

# 管理者（本番では ADMIN_EMAIL・ADMIN_PASSWORD を必ず設定する）
Admin.find_or_create_by!(email: ENV.fetch("ADMIN_EMAIL", "admin@example.com")) do |admin|
  admin.password = ENV.fetch("ADMIN_PASSWORD") do
    raise "本番では ADMIN_PASSWORD を設定してください" if Rails.env.production?
    "password"
  end
end

puts "完了しました"