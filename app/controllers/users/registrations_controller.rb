class Users::RegistrationsController < Devise::RegistrationsController
  before_action :reject_guest_user, only: [:edit, :update, :destroy]

  # 退会：データは消さずに「退会した印」をつける（管理画面から戻せる）
  def destroy
    resource.soft_delete!
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    redirect_to root_path, notice: "退会しました。ご利用ありがとうございました", status: :see_other
  end
end
