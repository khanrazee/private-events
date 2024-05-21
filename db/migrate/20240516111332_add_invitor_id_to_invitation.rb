class AddInvitorIdToInvitation < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :invited_by_id, :integer
  end
end
