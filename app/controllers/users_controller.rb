class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @created_events = current_user.created_events
    @attended_events = current_user.attended_events
  end

  private

  def set_user
    @user = current_user
  end
end
