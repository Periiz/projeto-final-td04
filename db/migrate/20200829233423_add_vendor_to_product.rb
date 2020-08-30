class AddVendorToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :collaborator, null: false, foreign_key: true
  end
end
