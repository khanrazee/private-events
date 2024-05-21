class AddStatusForInvitation < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :status, :integer, default: 0
  end
end
