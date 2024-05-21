class RenameColumnsInEventAttendancesTable < ActiveRecord::Migration[7.1]
  def change
    rename_column :event_attendances, :user_id, :attendee_id
    rename_column :event_attendances, :event_id, :attended_event_id
  end
end
