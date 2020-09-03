class AddNotificationToCollaborator < ActiveRecord::Migration[6.0]
  def change
    add_column :collaborators, :notifications_number, :integer, default: 0
  end
end
