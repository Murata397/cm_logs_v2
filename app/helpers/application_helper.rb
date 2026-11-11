module ApplicationHelper
  # 投稿・編集ができる人か（ログイン中で、ゲストではない）
  def can_post?
    user_signed_in? && !current_user.guest?
  end

  # ゲストの見本データにつける「サンプル」の印
  def sample_badge(user)
    return unless user&.guest?
    tag.span("サンプル", class: "c-badge c-badge--sample")
  end
end
