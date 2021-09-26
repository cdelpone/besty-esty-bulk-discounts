class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity
      t.decimal :percentage
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
