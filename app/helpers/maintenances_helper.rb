module MaintenancesHelper
  DIFFICULTY_LABELS = { "easy" => "簡単", "normal" => "普通", "hard" => "難しい" }.freeze

  # 難易度を日本語に
  def difficulty_label(maintenance)
    DIFFICULTY_LABELS[maintenance.work_difficulty]
  end

  # 分を「1時間30分」のような表示に
  def work_time_label(minutes)
    return "—" if minutes.blank?

    hours, mins = minutes.divmod(60)
    return "#{mins}分" if hours.zero?
    mins.zero? ? "#{hours}時間" : "#{hours}時間#{mins}分"
  end

  # 金額を「3,000円」のような表示に
  def yen(amount)
    amount.nil? ? "—" : "#{number_with_delimiter(amount)}円"
  end
end