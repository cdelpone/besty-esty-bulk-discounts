require 'faraday'
require 'json'

class PublicHolidaysClient
  class << self
    def holiday_info
      response = Faraday.get("https://date.nager.at/api/v3/NextPublicHolidays/us")
      parse_data(response)
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
