require 'rails_helper'
# rspec spec/features/bulk_discounts/index_spec.rb
RSpec.describe 'Merchant Bulk Discounts Index Page' do
  describe 'Merchant Bulk Discounts Index Page' do
    before :each do
      @json_response = File.read('spec/fixtures/response.json')

      stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/us").
      to_return(status: 200, body: @json_response, headers: {})

      @service = PublicHolidaysService.new

      @merchant1 = create :merchant
      @bulk_discountA = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 10, percentage: 20 }
      @bulk_discountB = create :bulk_discount, { merchant_id: @merchant1.id, threshold: 15, percentage: 30 }

      visit merchant_bulk_discounts_path(@merchant1)
    end

    it 'lists bulk discount attributes' do
      expect(page).to have_content(@bulk_discountA.threshold)
      expect(page).to have_content('20%')
      expect(page).to have_content(@bulk_discountA.id)
      expect(page).to have_content(@bulk_discountB.threshold)
      expect(page).to have_content(@bulk_discountB.id)
    end

    it 'links bulk discounts to show page' do
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

    it 'displays the next three public holidays and the date' do
      expect(page).to have_content('Upcoming Holidays')
      expect(page).to have_content("Columbus Day on 2021-10-11")
      expect(page).to have_content("Veterans Day on 2021-11-11")
      expect(page).to have_content("Thanksgiving Day on 2021-11-25")
    end
  end
end
