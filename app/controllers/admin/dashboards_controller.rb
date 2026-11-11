class Admin::DashboardsController < Admin::BaseController
  def show
    @counts = {
      users: User.kept.where.not(email: User::GUEST_EMAIL).count,
      deleted_users: User.soft_deleted.count,
      maintenances: Maintenance.kept.published.count,
      drafts: Maintenance.kept.draft.count,
      groups: Group.kept.count,
      comments: Comment.kept.count
    }
    @recent_users = User.where.not(email: User::GUEST_EMAIL).order(created_at: :desc).limit(5)
    @recent_maintenances = Maintenance.includes(:user).order(created_at: :desc).limit(5)
  end
end
