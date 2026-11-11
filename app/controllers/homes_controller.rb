class HomesController < ApplicationController
  def top
    @latest = Maintenance.visible.latest.includes(:user, :car, images_attachments: :blob).limit(3)
  end
end
