class AddDomainToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :seller_domain, :string
  end
end
