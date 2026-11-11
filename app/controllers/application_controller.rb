class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # ゲストユーザーは投稿・編集・削除をできないようにする
  def reject_guest_user
    return unless current_user&.guest?

    redirect_back fallback_location: root_path,
                  alert: "ゲストユーザーは閲覧のみできます。投稿するには新規登録をお願いします。"
  end

  # 管理者がログインしたら管理画面へ、ログアウトしたら管理者のログイン画面へ
  def after_sign_in_path_for(resource)
    resource.is_a?(Admin) ? admin_root_path : super
  end

  def after_sign_out_path_for(scope)
    scope == :admin ? new_admin_session_path : super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :introduction, :profile_image ])
  end
end
