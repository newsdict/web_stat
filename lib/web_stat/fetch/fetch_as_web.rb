require 'mechanize'
module WebStat
  class FetchAsWeb < Fetch
    # initialize class
    # @param [String] url
    def initialize(url)
      @url = original_url(url)
      @html = get_url(@url)
      @nokogiri = ::Nokogiri::HTML(@html)
    end
  end
end
