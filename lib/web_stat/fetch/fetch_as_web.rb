require 'mechanize'
module WebStat
  class FetchAsWeb < Fetch
    attr_accessor :url
    
    # initialize class
    # @param [String] url
    def initialize(url)
      @url = url
      @html = get_url(url).force_encoding("utf-8")
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