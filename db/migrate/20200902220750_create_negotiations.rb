class CreateNegotiations < ActiveRecord::Migration[6.0]
  def change
    create_table :negotiations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :collaborator, null: false, foreign_key: true
      t.datetime :date_of_start
      t.datetime :date_of_end
      t.decimal :final_price
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
