require 'mechanize'
module WebStat
  class FetchAsWeb < Fetch
    attr_accessor :url
    
    # initialize class
    # @param [String] url
    def initialize(url)
      @url = url
      agent = Mechanize.new { |_agent| _agent.user_agent = WebStat::Configure.get["user_agent"] }
      # Enable to read Robots.txt
      agent.robots = true
      @html = agent.get(original_url, [], nil, { 'Accept-Language' => 'ja'}).body.force_encoding("utf-8")
      @nokogiri = ::Nokogiri::HTML(@html)
    end
    
    # Get original url
    def original_url
      if @url.match(/^http/)
        FinalRedirectUrl.final_redirect_url(@url)
      else
        @url
      end
    end
  end
end