require 'rails_helper'
# rspec spec/features/bulk_discounts/index_spec.rb
RSpec.describe 'Merchant Bulk Discounts Index Page' do
  describe 'Merchant Bulk Discounts Index Page' do
    before :each do
      @merchant1 = create :merchant
      @bulk_discountA = create :bulk_discount, { merchant_id: @merchant1.id, quantity: 10, percentage: 0.20 }
      @bulk_discountB = create :bulk_discount, { merchant_id: @merchant1.id, quantity: 15, percentage: 0.30 }

      visit merchant_bulk_discounts_path(@merchant1)
    end

    it 'lists bulk discount attributes' do
      expect(page).to have_content(@bulk_discountA.quantity)
      expect(page).to have_content('20%')
      expect(page).to have_content(@bulk_discountA.id)
      expect(page).to have_content(@bulk_discountB.quantity)
      expect(page).to have_content(@bulk_discountB.id)
    end

    it 'links items to show page' do
      expect(page).to have_link(@bulk_discountA.id)

      click_link @bulk_discountA.id

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discountA))
    end

    it 'has a link to create new discount' do
      expect(page).to have_link('Create New Discount')

      click_link 'Create New Discount'

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    end

    it 'deletes a bulk discount' do
      within "#bulk_discount-#{@bulk_discountA.id}" do
        expect(page).to have_link('Delete')

        click_link 'Delete'
      end
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to have_no_content(@bulk_discountA)
    end
  end
end
# it 'updates inv item status' do
#   within "#inv_item-#{@invoice_item1.id}" do
#     expect(find_field('invoice_item_status').value).to eq('pending')
#     select 'packaged'
#     click_on 'Update'
#   end
#   expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice1))
#
#   within "#inv_item-#{@invoice_item1.id}" do
#     expect(find_field('invoice_item_status').value).to eq('packaged')
#     expect(page).to have_content('packaged')
#   end
# end
