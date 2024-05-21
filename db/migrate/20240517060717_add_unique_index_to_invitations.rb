class AddUniqueIndexToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_index :invitations, [:event_id, :invitee_id], unique: true
  end
end
