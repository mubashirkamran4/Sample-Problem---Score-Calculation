class AddInvitationColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :can_invite, :boolean, default: false
    add_column :users, :inviter_id, :integer
    add_column :users, :score, :float, default: 0
  end
end
