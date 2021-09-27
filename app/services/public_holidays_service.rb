require 'faraday'
require 'json'

class PublicHolidaysService

  def name_and_date
    holiday_data_info.filter_map do |holiday|
      "#{holiday[:name]} on #{holiday[:date]}"
    end.take(3)
  end

  def holiday_name
    holiday_data_info.map do |holiday|
      holiday[:name]
    end
  end

  def holiday_date
    holiday_data_info.map do |holiday|
      holiday[:date]
    end
  end

  def holiday_data
    holiday_data_info.map do |holiday|
      "#{holiday[:name]} #{holiday[:date]}"
    end
  end

  private

  def holiday_data_info
    @holiday_info ||= PublicHolidaysClient.holiday_info
  end
end
