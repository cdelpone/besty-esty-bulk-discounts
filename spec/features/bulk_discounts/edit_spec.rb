require 'rails_helper'
# rspec spec/features/bulk_discounts/edit_spec.rb
RSpec.describe 'Merchant Bulk Discount Edit Page' do
  describe 'Merchant Bulk Discount Edit Page' do
    before :each do
      @merchant1 = create :merchant
      @bulk_discountA = create :bulk_discount, { merchant_id: @merchant1.id, quantity: 10, percentage: 0.20 }
      @bulk_discountB = create :bulk_discount, { merchant_id: @merchant1.id, quantity: 15, percentage: 0.30 }

      visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discountA)
    end

    it 'has a form to update the bulk discount' do
      within '#form' do
        expect(find_field('bulk_discount_quantity').value).to eq("#{@bulk_discountA.quantity}")

        fill_in 'Quantity', with: '20'
        fill_in 'Percentage', with: '1'

        click_button 'Submit'
      end
      
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discountA))
      expect(page).to have_content('100%')
      expect(page).to have_content('20')
    end

    it 'handles incorrect form submission' do
      # within '#form' do
      #   expect(find_field('item_name').value).to eq(@item.name)
      #   fill_in 'Name', with: ''
      #   click_button 'Submit'
      # end
      # within '#form' do
      #   expect(find_field('item_name').value).to eq(@item.name)
      # end
      # expect(page).to have_content('Do Better')
    end
  end
end
