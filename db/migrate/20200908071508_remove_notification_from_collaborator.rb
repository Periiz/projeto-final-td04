class RemoveNotificationFromCollaborator < ActiveRecord::Migration[6.0]
  def change
    remove_column :collaborators, :notifications_number, :integer
  end
end
