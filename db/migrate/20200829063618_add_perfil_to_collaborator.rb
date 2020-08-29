class AddPerfilToCollaborator < ActiveRecord::Migration[6.0]
  def change
    add_column :collaborators, :full_name, :string
    add_column :collaborators, :social_name, :string
    add_column :collaborators, :birth_date, :datetime
    add_column :collaborators, :position, :string
    add_column :collaborators, :sector, :string
  end
end
