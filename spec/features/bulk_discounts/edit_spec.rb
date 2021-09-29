require 'rails_helper'
# rspec spec/features/bulk_discounts/edit_spec.rb
RSpec.describe 'Merchant Bulk Discount Edit Page' do
  describe 'Merchant Bulk Discount Edit Page' do
    before :each do
      @merchant1 = create :merchant
      @bulk_discountA = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 10, percentage: 20 }
      @bulk_discountB = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 15, percentage: 30 }

      visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discountA)
    end

    it 'has a form to update the bulk discount' do
      within '#form' do
        expect(find_field('bulk_discount_threshold').value).to eq("#{@bulk_discountA.threshold}")
        expect(find_field('bulk_discount_percentage').value).to eq("#{@bulk_discountA.percentage}")

        fill_in 'Threshold', with: '20'
        fill_in 'Percentage', with: '50'

        click_button 'Submit'
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discountA))
      expect(page).to have_content('50%')
      expect(page).to have_content('20')
      expect(page).to have_content('Successfully Updated')
    end

    it 'handles incorrect threshold input' do
      within '#form' do
        expect(find_field('bulk_discount_threshold').value).to eq("#{@bulk_discountA.threshold}")
        expect(find_field('bulk_discount_percentage').value).to eq("#{@bulk_discountA.percentage}")

        fill_in 'Threshold', with: 'a'
        fill_in 'Percentage', with: '.5'

        click_button 'Submit'
      end
      within '#form' do
        expect(find_field('bulk_discount_threshold').value).to eq("#{@bulk_discountA.threshold}")
        expect(find_field('bulk_discount_percentage').value).to eq("#{@bulk_discountA.percentage}")
      end
      expect(page).to have_content('Do Better')
    end

    it 'handles incorrect percentage input' do
      within '#form' do
        expect(find_field('bulk_discount_threshold').value).to eq("#{@bulk_discountA.threshold}")
        expect(find_field('bulk_discount_percentage').value).to eq("#{@bulk_discountA.percentage}")

        fill_in 'Threshold', with: '1'
        fill_in 'Percentage', with: '125'

        click_button 'Submit'
      end
      within '#form' do
        expect(find_field('bulk_discount_threshold').value).to eq("#{@bulk_discountA.threshold}")
        expect(find_field('bulk_discount_percentage').value).to eq("#{@bulk_discountA.percentage}")
      end
      expect(page).to have_content('Do Better')
    end
  end
end
