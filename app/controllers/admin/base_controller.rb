# 管理画面のコントローラーの親。管理者としてログインしていないと入れない
class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  private

  # 「表示中」か「削除済み」か（URLの ?status=deleted で切り替える）
  def showing_deleted?
    params[:status] == "deleted"
  end
  helper_method :showing_deleted?

  def filter_by_status(scope)
    showing_deleted? ? scope.soft_deleted : scope.kept
  end

  def back_to(fallback, notice)
    redirect_back fallback_location: fallback, notice: notice, status: :see_other
  end
end
