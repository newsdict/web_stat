require 'mechanize'
module WebStat
  class INVALID_URL < ::IOError; end
  class FetchAsWeb < Fetch
    # initialize class
    # @param [String] url
    def initialize(url)
      unless url_valid?(url)
        raise WebStat::INVALID_URL, url
      end
      @url = original_url(url)
      @html = get_url(@url)
      @nokogiri = ::Nokogiri::HTML(@html)
    end
    
    # Validation url
    def url_valid?(url)
      regexp = Regexp.new("^https?://([a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9])\\\.([a-zA-Z]{2,})(/.*)?$", Regexp::IGNORECASE)
      regexp.match?(url)
    end 
  end
end
