require 'set'

class GitHubClient
  TURING_STAFF = %w(BrianZanti timomitchel scottalexandra jamisonordway)
  class << self
    def repo_info
      response = conn.get('/repos/tannerdale/little-esty-shop')
      parse_data(response)
    end

    def conn
      Faraday.new('https://api.github.com')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def repo_name
      response = conn.get('/repos/tannerdale/little-esty-shop')
      parse_data(response)[:name]
    end

    def contribution_stats
      response = conn.get('/repos/tannerdale/little-esty-shop/stats/contributors')
      Set.new(parse_data(response))
    end


    def repo_pulls
      # need to account for second page of results
      response = conn.get('/repos/tannerdale/little-esty-shop/pulls?state=closed&per_page=100')
      parse_data(response)
    end
  end
end