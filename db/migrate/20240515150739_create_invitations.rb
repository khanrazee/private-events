class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.integer :event_id
      t.integer :invitee_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
