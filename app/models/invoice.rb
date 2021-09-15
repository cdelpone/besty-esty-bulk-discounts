class Invoice < ApplicationRecord
  self.primary_key = :id

  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  enum status: ['in progress', 'completed', 'cancelled']

  scope :merchant_invoices, ->(merchant) {
    joins(:items).where('items.merchant_id = ?', merchant)
  }

  scope :for_merchant, ->(merchant) {
    merchant_invoices(merchant).order(:created_at).distinct
  }

  scope :merchant_fav_customers, ->(merchant) {
    merchant_invoices(merchant).joins(:customer, :transactions).where("transactions.result = 0").group("customers.id").order("count(transactions.id) desc").limit(5).pluck("customers.first_name ||' '|| customers.last_name")
  }
end
