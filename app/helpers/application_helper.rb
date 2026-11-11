module ApplicationHelper
  # 投稿・編集ができる人か（ログイン中で、ゲストではない）
  def can_post?
    user_signed_in? && !current_user.guest?
  end
end
