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
      if @url.match?(/\.pdf$/)
        title = nil
        body = nil
        URI.open(@url) do |io|
          reader = PDF::Reader.new(io)
          if reader.info.key?(:Title)
            title = reader.info[:Title]
          else
            title = File.basename(@url, ".pdf")
          end
          body = reader.pages.first.text
        end
        @html = <<-"EOS"
          <html>
          <head>
            <title>#{title}</title>
          </head>
          <body>
            #{body}
          </body>
          </html>
        EOS
      else
        @html = get_url(@url)
      end
      @nokogiri = ::Nokogiri::HTML(@html)
    end
    
    # Validation url
    def url_valid?(url)
      regexp = Regexp.new("^https?://([a-zA-Z0-9][a-zA-Z0-9\\\-\.]{1,61}[a-zA-Z0-9])\\\.([a-zA-Z]{2,})(.*)?$", Regexp::IGNORECASE)
      regexp.match?(url)
    end 
  end
end
