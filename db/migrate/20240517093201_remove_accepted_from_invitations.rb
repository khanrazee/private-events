class RemoveAcceptedFromInvitations < ActiveRecord::Migration[7.1]
  def change
    remove_column :invitations, :accepted, :boolean
  end
end
