require 'uri'
require 'digest'
require 'nokogiri'
require 'ruby-readability'
require 'final_redirect_url'
module WebStat
  class Fetch
    attr_accessor :html, :nokogiri, :original_url
    
    # Get title
    # @return [String] title
    def title
      begin
        title = @nokogiri.title.split(/#{WebStat::Configure.get["regex_to_sprit_title"]}/, 2).first
        if title.length < WebStat::Configure.get["min_length_of_meta_title"]
          title = @nokogiri.css("h1").first.content
        end
      rescue
        title = @nokogiri.title
      end
      title.strip
    end
    
    # Get name of domain 
    def site_name
      begin
        site_name = @nokogiri.title.split(/#{WebStat::Configure.get["regex_to_sprit_title"]}/, 2).last
      rescue
        site_name = @nokogiri.title
      end
      site_name.strip
    end
      
    # Get main section
    def content
      Readability::Document.new(@html).content  
    end
      
    # Get temporary path of image
    def eyecatch_image_path
      path = nil
      WebStat::Configure.get["eyecatch_image_xpaths"].each do |xpath|
        if @nokogiri.xpath(xpath).first.respond_to?(:value)
          path = @nokogiri.xpath(xpath).first.value
          break
        end
      end
      if @url && path.is_a?(String) && !path.match(/^http/) 
        if path.match(/^\//)
          path = "#{URI.parse(@url).scheme}://#{URI.parse(@url).host}#{path}"
        else
          path = "#{URI.parse(@url).scheme}://#{URI.parse(@url).host}/#{URI.parse(@url).path}/#{path}"
        end
      end
      path
    end
    
    # Get local path to save url
    # @param [String] url
    def save_local_path(url)
      return nil if url.nil? || !url.match(/^http/)
      tmp_file = "/tmp/#{Digest::SHA1.hexdigest(url)}"
      File.open(tmp_file, "w") do |_file|
        _file.puts(get_url(url))
      end
      tmp_file
    end
    
    # Get url
    # @param [String] url
    def get_url(url)
      agent = Mechanize.new { |_agent| _agent.user_agent = WebStat::Configure.get["user_agent"] }
      # Enable to read Robots.txt
      agent.robots = true
      agent.get(url, [], nil, { 'Accept-Language' => 'ja'}).body
    end
    
    # Get the informations of @url
    def stat
      {
        title: title,
        site_name: site_name,
        content: content,
        url: original_url,
        eyecatch_image_path: save_local_path(eyecatch_image_path)
      }
    end
  end
end