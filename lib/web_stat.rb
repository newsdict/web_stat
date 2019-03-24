require "bundler"
Dir.glob("**/*.rb", base: 'lib').each do |file|
  require(file)
end

module WebStat
  class << self
    # Get web page's stat by url
    def stat_by_url(url)
      web_stat = WebStat::FetchAsWeb.new(url)
      web_stat.stat
    end
    
    # Get web page's stat by html
    def stat_by_html(html)
      web_stat = WebStat::FetchAsHtml.new(html)
      web_stat.stat
    end
  end
end
