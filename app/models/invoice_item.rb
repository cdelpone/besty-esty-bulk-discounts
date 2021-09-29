class InvoiceItem < ApplicationRecord
  self.primary_key = :id

  belongs_to :item
  belongs_to :invoice

  validates_presence_of :status

  enum status: %w[pending packaged shipped]

  scope :not_shipped, lambda {
    where.not(status: 2)
  }

  scope :revenue, lambda {
    sum('unit_price * quantity')
  }

  def revenue
    unit_price * quantity
  end

  def discount_applied
    item.merchant.bulk_discounts.where('threshold <= ?', quantity).order(:percentage).last
  end

  def discount_id_applied
    discount_applied.id
  end

  def discount_subtotal
    if discount_applied.percentage.nil?
      0
    else
      (revenue * (discount_applied.percentage / 100.00)).round(2)
    end
  end
end
