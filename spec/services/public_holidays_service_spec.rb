require 'rails_helper'
# rspec spec/services/public_holidays_service_spec.rb
RSpec.describe 'public holidays api' do
  before :each do
    @json_response = File.read('spec/fixtures/response.json')

    stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/us").
    to_return(status: 200, body: @json_response, headers: {})

    @service = PublicHolidaysService.new
  end

  it 'exists' do
    expect(@service).to be_an_instance_of(PublicHolidaysService)
  end

  it 'can hit api' do
    expect(@service.holiday_info).to be_an(Array)
  end

  it 'can return name and date from api' do
    expect(@service.holiday_info.first[:name]).to eq("Columbus Day")
    expect(@service.holiday_info.first[:date]).to eq("2021-10-11")
  end
end
