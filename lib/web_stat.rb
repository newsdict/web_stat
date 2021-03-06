require "bundler"

require 'cld'
require 'uri'
require 'erb'
require 'digest'
require 'logger'
require 'sanitize'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'pdf/reader'
require 'ruby-readability'
require 'selenium-webdriver'
require 'google/apis/youtube_v3'

require "helpers/web_drive_helper"
require "web_stat/final_redirect_url"
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
    # @param [Hash] Specify a dictionary for each language code. example ) {"ja": /***/**.dic, "other": /***/***.dic}
    def stat_by_web(url, userdics: nil)
      web_stat = WebStat::FetchAsWeb.new(url)
      web_stat.stat(userdics: userdics)
    end

    # Get web page's stat by url
    # @param String url
    def stat_by_url(url, userdics: nil)
      stat_by_web(url, userdics: userdics)
    end
    
    # Get web page's stat by html
    # @param String html
    # @param [String] url
    # @param [Hash] Specify a dictionary for each language code. example ) {"ja": /***/**.dic, "other": /***/***.dic}
    def stat_by_html(html, url=nil, userdics: nil)
      web_stat = WebStat::FetchAsHtml.new(html)
      web_stat.url = url unless url.nil?
      web_stat.stat(userdics: userdics)
    end
  end
end
