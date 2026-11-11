class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def profile_params
    params.expect(user: [ :name, :introduction, :profile_image ])
  end
end
