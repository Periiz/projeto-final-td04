class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :text
      t.references :product, null: false, foreign_key: true
      t.references :collaborator, null: false, foreign_key: true
      t.datetime :post_date

      t.timestamps
    end
  end
end
