class AddBuyerToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :buyer_id, :integer, default: -1
  end
end
