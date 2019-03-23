module WebStat
  class FetchAsHtml < Fetch
    attr_accessor :html
    
    # initialize class
    # @param [String] html
    def initialize(html)
      @html = html
    end
  end
end