require 'nokogiri'
require 'ruby-readability'
require 'final_redirect_url'
module WebStat
  class Fetch
    attr_accessor :html, :nokogiri
    
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
      path
    end
    
    # Get the informations of @url
    def stat
      {
        title: title,
        site_name: site_name,
        content: content,
        url: original_url,
        eyecatch_image_path: eyecatch_image_path
      }
    end
  end
end