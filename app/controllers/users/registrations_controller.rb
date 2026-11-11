class Users::RegistrationsController < Devise::RegistrationsController
  before_action :reject_guest_user, only: [:edit, :update, :destroy]
end
