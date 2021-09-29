require 'rails_helper'
# rspec spec/models/invoice_item_spec.rb
RSpec.describe InvoiceItem, type: :model do
  describe 'relationships/validations' do
    it { belong_to :item }
    it { belong_to :invoice }

    it { should validate_presence_of :status }
  end

  describe 'enum' do
    let(:status) { %w[pending packaged shipped] }
    it 'has the right index' do
      status.each_with_index do |item, index|
        expect(InvoiceItem.statuses[item]).to eq(index)
      end
    end
  end

  describe 'scopes and class methods' do
    let(:invoice) { create :invoice }
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
    let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, status: 0, quantity: 3, unit_price: 100 } }
    let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id, status: 1, quantity: 2, unit_price: 100 } }
    let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id, status: 2, quantity: 1, unit_price: 150 } }

    it 'has not shipped items' do
      expect(InvoiceItem.not_shipped).to eq([inv_item1, inv_item2])
    end

    it 'has a total revenue' do
      expect(InvoiceItem.revenue).to eq(650)
    end

    it 'calcs total revenue' do
      expect(inv_item1.revenue).to eq(300)
    end

    it 'can return correct discount applied' do
      bulk_discountA = create :bulk_discount, { merchant_id: merchant.id, threshold: 7, percentage: 25 }
      bulk_discountB = create :bulk_discount, { merchant_id: merchant.id, threshold: 2, percentage: 50 }

      expect(inv_item1.discount_applied.percentage).to eq(50)
      expect(inv_item1.discount_applied).to eq(bulk_discountB)
      expect(inv_item1.discount_applied).not_to eq(bulk_discountA)
      expect(inv_item1.discount_applied.percentage).not_to eq(25)
    end

    it 'can return discount subtotal' do
      bulk_discountA = create :bulk_discount, { merchant_id: merchant.id, threshold: 7, percentage: 25 }
      bulk_discountB = create :bulk_discount, { merchant_id: merchant.id, threshold: 2, percentage: 50 }
      #bulk_discountB should be applied with a 50% discount on the revenue for inv_item1 (100 * 3)
      expect(inv_item1.discount_subtotal).to eq(150)
    end

    it 'can return the discount id that was applied' do
      bulk_discountA = create :bulk_discount, { id: 5, merchant_id: merchant.id, threshold: 2, percentage: 25 }
      bulk_discountB = create :bulk_discount, { id: 6, merchant_id: merchant.id, threshold: 3, percentage: 50 }
      expect(inv_item1.discount_id_applied).to eq(6)
      expect(inv_item2.discount_id_applied).to eq(5)
    end
  end
end
