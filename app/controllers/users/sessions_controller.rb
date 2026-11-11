class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    sign_in User.guest
    redirect_to maintenances_path, notice: "ゲストユーザーとしてログインしました"
  end

  # ゲストのまま新規登録画面は開けないので、ログアウトしてから移動する
  def guest_to_sign_up
    sign_out(current_user) if current_user&.guest?
    redirect_to new_user_registration_path, notice: "ゲストからログアウトしました。アカウントを作成してください", status: :see_other
  end
end
