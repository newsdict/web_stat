# ref) https://github.com/indyarocks/final_redirect_url
# customize
#  Changed 
module WebStat
  class FinalRedirectUrl
    class << self
      def final_redirect_url(url, options={})
        final_url = ''
        if is_valid_url?(url)
          begin
            redirect_lookup_depth = options[:depth].to_i > 0 ? options[:depth].to_i : 10
            response_uri = get_final_redirect_url(url, redirect_lookup_depth)
            final_url =  url_string_from_uri(response_uri)
          rescue Exception => ex
            # nothing
          end
        end
        final_url
      end
    
      private
      def is_valid_url?(url)
        url.to_s.match? URI::regexp(['http', 'https'])
      end
      def get_final_redirect_url(url, limit = 10)
        return url if limit <= 0
        uri = URI.parse(url)
        response = ::Net::HTTP.get_response(uri)
        if response.class == Net::HTTPOK
          if WebStat::Configure.get["use_chromedirver"]
            return URI.parse(WebStat::WebDriverHelper.get_last_url(uri))
          else
            return URI.parse(uri)
          end
        else
          redirect_location = response['location']
          location_uri = URI.parse(redirect_location)
          if location_uri.host.nil?
            redirect_location = uri.scheme + '://' + uri.host + redirect_location
          end
          warn "redirected to #{redirect_location}"
          get_final_redirect_url(redirect_location, limit - 1)
        end
      end
      def url_string_from_uri(uri)
        url_str = "#{uri.scheme}://#{uri.host}#{uri.request_uri}"
        if uri.fragment
          url_str = url_str + "##{uri.fragment}"
        end
        url_str
      end
    end
  end
end