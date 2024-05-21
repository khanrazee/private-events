class RenameColumnsInEventAttendances < ActiveRecord::Migration[7.1]
  def change
    rename_column :event_attendances, :attendee_id, :user_id
    rename_column :event_attendances, :attended_event_id, :event_id
  end
end
