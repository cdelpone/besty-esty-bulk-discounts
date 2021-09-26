class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :quantity,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1 }
  validates :percentage,
            numericality: { greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100 }
end
