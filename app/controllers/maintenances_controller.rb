class MaintenancesController < ApplicationController
  def index
    @maintenances = Maintenance.visible.latest.includes(:user, :car, images_attachments: :blob)
  end

  def show
    @maintenance = Maintenance.visible
                              .includes(:user, :car, :tools, steps: { image_attachment: :blob })
                              .find(params[:id])

    # 同じ車種の、ほかの整備記録（最大3件）
    @related = Maintenance.visible
                          .joins(:car)
                          .where(cars: { car_model: @maintenance.car.car_model })
                          .where.not(id: @maintenance.id)
                          .includes(:car)
                          .latest
                          .limit(3)
  end
end