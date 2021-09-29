# frozen_string_literal: true

require 'rails_helper'
# rspec spec/models/invoice_spec.rb
RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods/scopes' do
    let(:invoice) { create :invoice }
    let(:status) { ['in progress', 'completed', 'cancelled'] }
    let!(:merchant) { create :merchant }
    let!(:customer) { create :customer }
    let!(:customer2) { create :customer }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item2) { create :item, { merchant_id: merchant.id } }
    let!(:item3) { create :item, { merchant_id: merchant.id } }
    let!(:invoice1) { create :invoice, { customer_id: customer.id } }
    let!(:invoice2) { create :invoice, { customer_id: customer2.id } }
    let!(:invoice3) { create :invoice, { customer_id: customer2.id } }
    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: 1 } }
    let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id } }
    let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id } }
    let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id } }

    context 'for merchants' do
      let!(:merchant) { create :merchant }
      let!(:customer) { create :customer }
      let!(:item1) { create :item, { merchant_id: merchant.id } }
      let!(:item2) { create :item, { merchant_id: merchant.id } }
      let!(:item3) { create :item, { merchant_id: merchant.id } }
      let!(:invoice1) { create :invoice, { customer_id: customer.id, status: 0 } }
      let!(:invoice2) { create :invoice, { customer_id: customer.id, status: 0 } }
      let!(:invoice3) { create :invoice, { customer_id: customer.id, status: 1 } }
      let!(:invoice4) { create :invoice, { customer_id: customer.id, status: 2 } }
      let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, status: 0 } }
      let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id, status: 1 } }
      let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id, status: 2 } }

      it '#incomplete_invoices' do
        expect(Invoice.incomplete_invoices).to eq([invoice1])
      end

      it 'has a transaction count' do
        result = Invoice.joins(:transactions).transactions_count.group(:id)
        result = result.sum(&:transaction_count)

        expect(result).to eq(2)
      end

      it 'has total revenues' do
        expected = [inv_item1, inv_item2, inv_item3].sum do |inv|
          inv.unit_price * inv.quantity
        end
        result = Invoice.joins(:invoice_items).total_revenues.group(:id)
        result = result.sum(&:revenue)

        expect(result).to eq(expected)
      end
    end
  end

  describe 'instance methods' do
    describe 'total revenue' do
      let!(:customer) { create :customer }
      let!(:merchant) { create :merchant }
      let!(:invoice) { create :invoice, { customer_id: customer.id } }
      let!(:item1) { create :item, { merchant_id: merchant.id } }
      let!(:item2) { create :item, { merchant_id: merchant.id } }
      let!(:item3) { create :item, { merchant_id: merchant.id } }
      let!(:inv_item1) { create :invoice_item, { invoice_id: invoice.id, item_id: item1.id, unit_price: 100, quantity: 1 } }
      let!(:inv_item2) { create :invoice_item, { invoice_id: invoice.id, item_id: item2.id, unit_price: 150, quantity: 2 } }
      let!(:inv_item3) { create :invoice_item, { invoice_id: invoice.id, item_id: item3.id, unit_price: 300, quantity: 1 } }

      it '#total_revenues' do
        expect(invoice.total_revenue).to eq(700)
      end
    end

    it 'finds discount eligible items' do
      merchant = create :merchant
      merchant2 = create :merchant
      customer = create :customer
      invoice1 = create :invoice, { customer_id: customer.id, created_at: DateTime.new(2021, 9, 18) }
      invoice2 = create :invoice, { customer_id: customer.id, created_at: DateTime.new(2021, 9, 17) }
      item1 = create :item, { merchant_id: merchant.id }
      item2 = create :item, { merchant_id: merchant.id }
      item3 = create :item, { merchant_id: merchant.id }
      item4 = create :item, { merchant_id: merchant.id }
      inv_item1 = create :invoice_item, { invoice_id: invoice1.id, item_id: item1.id, unit_price: 30, quantity: 3, status: 0 }
      # inv_item1 - 90
      inv_item2 = create :invoice_item, { invoice_id: invoice1.id, item_id: item2.id, unit_price: 40, quantity: 1, status: 1 }
      # inv_item2 - 40
      inv_item3 = create :invoice_item, { invoice_id: invoice1.id, item_id: item3.id, unit_price: 10, quantity: 3, status: 2 }
      # inv_item3 - 30
      inv_item4 = create :invoice_item, { invoice_id: invoice1.id, item_id: item4.id, unit_price: 20, quantity: 3, status: 2 }
      # inv_item4 - 60
      inv_item5 = create :invoice_item, { invoice_id: invoice2.id, item_id: item4.id, unit_price: 20, quantity: 3, status: 2 }
      # inv_item5 - 60
      bulk_discountA = create :bulk_discount, { merchant_id: merchant.id, threshold: 1, percentage: 25 }
      #invoice1 = total of 220 with a 25% discount on threshold of 2, to be a discount of 55
      #invoice2 = total of 60 with a 25% discount on threshold of 2, to be a discount of 15
      expect(invoice1.total_revenue).to eq(220)
      expect(invoice1.discounted_revenue).to eq(55)
      expect(invoice2.total_revenue).to eq(60)
      expect(invoice2.discounted_revenue).to eq(15)

      bulk_discountB = create :bulk_discount, { merchant_id: merchant.id, threshold: 2, percentage: 50 }
      expect(invoice1.discounted_revenue).to eq(100)
      expect(invoice2.discounted_revenue).to eq(30)

      bulk_discountC = create :bulk_discount, { merchant_id: merchant.id, threshold: 2, percentage: 75 }
      expect(invoice1.discounted_revenue).to eq(145)
      expect(invoice2.discounted_revenue).to eq(45)
    end
  end
end
