require 'mechanize'
module WebStat
  class FetchAsWeb < Fetch
    attr_accessor :html
    
    # initialize class
    # @param [String] url
    def initialize(url)
      agent = Mechanize.new { |_agent| _agent.user_agent = WebStat::Configure.get["user_agent"] }
      # Enable to read Robots.txt
      agent.robots = true
      @html = agent.get(url, [], nil, { 'Accept-Language' => 'ja'}).body.force_encoding("utf-8")
    end
  end
end