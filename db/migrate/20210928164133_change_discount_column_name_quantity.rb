class ChangeDiscountColumnNameQuantity < ActiveRecord::Migration[5.2]
  def change
    rename_column :bulk_discounts, :quantity, :threshold
  end
end
