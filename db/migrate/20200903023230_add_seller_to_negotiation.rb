class AddSellerToNegotiation < ActiveRecord::Migration[6.0]
  def change
    add_column :negotiations, :seller_id, :integer
  end
end
