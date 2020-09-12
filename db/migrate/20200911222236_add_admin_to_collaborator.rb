class AddAdminToCollaborator < ActiveRecord::Migration[6.0]
  def change
    add_column :collaborators, :admin, :boolean, default: false
  end
end
