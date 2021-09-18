class Invoice < ApplicationRecord
  self.primary_key = :id

  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  enum status: ['in progress', 'completed', 'cancelled']

  scope :pending_invoices, -> {
    where(status: 0).order(:created_at)
  }

  def total_revenue
    invoice_items.revenue
  end
end
