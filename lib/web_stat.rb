require "bundler"
require "web_stat/categorize"
require "web_stat/configure"
require "web_stat/errors"
require "web_stat/fetch"
require "web_stat/tag"
require "web_stat/version"
require "web_stat/fetch/fetch_as_html"
require "web_stat/fetch/fetch_as_web"

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
