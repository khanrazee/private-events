class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
    mark_all_as_read
  end

  private

  def mark_all_as_read
    @notifications.update_all(read_at: Time.current)
  end
end
