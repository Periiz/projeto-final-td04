class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :product_category, null: false, foreign_key: true
      t.string :description
      t.decimal :sale_price

      t.timestamps
    end
  end
end
