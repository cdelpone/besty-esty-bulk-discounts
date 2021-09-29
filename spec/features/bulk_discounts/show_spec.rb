require 'rails_helper'
# rspec spec/features/bulk_discounts/show_spec.rb
RSpec.describe 'Merchant Bulk Discount Show Page' do
  describe 'Merchant Bulk Discount Show Page' do
    before :each do
      @merchant1 = create :merchant
      @bulk_discountA = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 10, percentage: 20 }
      @bulk_discountB = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 15, percentage: 30 }

      visit merchant_bulk_discount_path(@merchant1, @bulk_discountA)
    end

    it 'lists bulk discount attributes' do
      expect(page).to have_content(@bulk_discountA.threshold)
      expect(page).to have_content('20%')
      expect(page).to have_content(@bulk_discountA.id)
      expect(page).to have_no_content(@bulk_discountB.threshold)
      expect(page).to have_no_content('30%')
      expect(page).to have_no_content(@bulk_discountB.id)
    end

    it 'links to update bulk discount' do
      expect(page).to have_link('Update')

      click_link 'Update'

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discountA))
    end
  end
end
