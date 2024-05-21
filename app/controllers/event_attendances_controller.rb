class EventAttendancesController < ApplicationController
  before_action :authenticate_user!

  def create
    event = Event.find(params[:event_id])
    current_user.attended_events << event
    redirect_to event
  end

  def destroy
    event_attendance = EventAttendance.find(params[:id])
    event_attendance.destroy
    redirect_to events_path
  end
end
