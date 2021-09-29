require 'rails_helper'
# rspec spec/features/admin/invoices/show_spec.rb

RSpec.describe 'Admin Invoice Show Page' do
  before do
    @customer = create(:customer)
    @merchant = create :merchant

    @item_1 = create :item, { merchant_id: @merchant.id }
    @item_2 = create :item, { merchant_id: @merchant.id }
    @item_3 = create :item, { merchant_id: @merchant.id }

    @invoice = create(:invoice, customer_id: @customer.id)

    @invoice_item_1 = create :invoice_item,
                            { invoice_id: @invoice.id, item_id: @item_1.id, unit_price: 50, quantity: 2, status: 0 }
    @invoice_item_2 = create :invoice_item,
                            { invoice_id: @invoice.id, item_id: @item_2.id, unit_price: 20, quantity: 2, status: 1 }
    @invoice_item_3 = create :invoice_item,
                            { invoice_id: @invoice.id, item_id: @item_3.id, unit_price: 10, quantity: 1, status: 2 }

    @bulk_discountA = create :bulk_discount, { merchant_id: @merchant.id, threshold: 1, percentage: 20 }
    @bulk_discountB = create :bulk_discount, { merchant_id: @merchant.id, threshold: 5, percentage: 50 }

    visit admin_invoice_path(@invoice.id)
  end

  describe 'i see information related to invoice' do
    it 'when i visit an admin invoice show page' do
      expect(current_path).to eq(admin_invoice_path(@invoice.id))
    end

    it 'has invoice id, status, created, cust first and last' do
      expect(page).to have_content(@invoice.id.to_s)
      expect(page).to have_content(@invoice.status.to_s)
      expect(page).to have_content(@invoice.created_at.strftime('%A, %B %e, %Y'))
      expect(page).to have_content(@invoice.customer.first_name)
      expect(page).to have_content(@invoice.customer.last_name)
    end

    it 'has item name, quant, price sold, and inv. item status' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_2.quantity)
      expect(page).to have_content(@invoice_item_3.quantity)
      expect(page).to have_content(@invoice_item_1.unit_price)
      expect(page).to have_content(@invoice_item_2.unit_price)
      expect(page).to have_content(@invoice_item_3.unit_price)
      expect(page).to have_content(@invoice_item_1.status)
      expect(page).to have_content(@invoice_item_2.status)
      expect(page).to have_content(@invoice_item_3.status)
    end
  end

  describe 'total revenue / updating status' do
    let!(:customer) { create :customer }
    let!(:merchant) { create :merchant }
    let!(:invoice) { create :invoice, { customer_id: customer.id } }
    let!(:item) { create :item, { merchant_id: merchant.id } }
    let!(:invoice_item) do
      create :invoice_item, { invoice_id: invoice.id, item_id: item.id, unit_price: 13_000, quantity: 1 }
    end

    it 'shows the total revenue' do
      visit admin_invoice_path(invoice)

      within '#invoice-attr' do
        expect(page).to have_content('$130.00')
      end
    end

    it 'has button to update the status' do
      select 'cancelled', from: 'invoice_status'
      click_button 'Update Status'

      expect(find_field('invoice_status').value).to eq('cancelled')

      expect(current_path).to eq(admin_invoice_path(@invoice))
    end

    context 'Invoice & Bulk Discounts' do
      it 'displays revenue with discounts and without discounts' do
        expect(page).to have_content('Total Revenue')
        expect(page).to have_content('Total Revenue After Discounts Applied')

        expect(@invoice.discounted_from_revenue).to eq(30)
        expect(@invoice.total_discounted_revenue).to eq(120)

        expect(page).to have_content(@invoice.total_discounted_revenue)
      end
    end
  end
end
