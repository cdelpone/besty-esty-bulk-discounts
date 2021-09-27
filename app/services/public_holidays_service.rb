require 'json'

class PublicHolidaysService

  def holiday_info
    response = Faraday.get("https://date.nager.at/api/v3/NextPublicHolidays/us")
    parse_data(response)
  end

  def parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def name_and_date
    holiday_info.filter_map do |holiday|
      "#{holiday[:name]} on #{holiday[:date]}"
    end.take(3)
  end
end
