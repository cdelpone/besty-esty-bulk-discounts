require 'rails_helper'
# rspec spec/features/bulk_discounts/new_spec.rb
RSpec.describe 'Merchant Bulk Discounts New Page' do
  describe 'Merchant Bulk Discounts New Page' do
    before :each do
      @json_response = File.read('spec/fixtures/response.json')
      stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/us").
      to_return(status: 200, body: @json_response, headers: {})
      @service = PublicHolidaysService.new

      @merchant1 = create :merchant
      @bulk_discountA = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 10, percentage: 0.20 }

      visit new_merchant_bulk_discount_path(@merchant1)
    end

    it 'has a form to create new item' do
      within '#form' do
        expect(page).to have_content('Threshold')
        expect(page).to have_content('Percentage')
        expect(page).to have_button('Submit')
      end
    end

    it 'redirects to merchant bulk discount index and shows new discount' do
      fill_in 'Threshold', with: 5
      fill_in 'Percentage', with: 10

      click_button 'Submit'
      @merchant1.reload

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to have_content(5)
      expect(page).to have_content("10%")
    end
  end
end
