module WebStat
  class FetchAsHtml < Fetch
    
    # initialize class
    # @param [String] html
    def initialize(html)
      @html = html
      @nokogiri = ::Nokogiri::HTML(@html)
    end
  end
end
