require 'nokogiri'
module WebStat
  class Fetch
    attr_accessor :html
    
    # Get html
    # @return [String] HTML
    def get_html; end
    
    # Get title
    # @return [String] title
    def title
      document = ::Nokogiri::HTML(@html)
      begin
        title = document.title.split(/#{WebStat::Configure.get["regex_to_sprit_title"]}/, 2).first
        if title.length < WebStat::Configure.get["min_length_of_meta_title"]
          title = document.css("h1").first.content
        end
      rescue
        title = document.title
      end
      title.strip
    end
    
    # Get name of domain 
    def site_name
      document = ::Nokogiri::HTML(@html)
      begin
        site_name = document.title.split(/#{WebStat::Configure.get["regex_to_sprit_title"]}/, 2).last
      rescue
        site_name = document.title
      end
      site_name.strip
    end
      
    # Get main section
    def content; end
      
    # Get original url
    def original_url; end
      
    # Get temporary path of image
    def image_local_path; end
    
    # Get the informations of @url
    def stat
      {
        title: title,
        site_name: site_name,
        content: content,
        url: original_url,
        image_path: image_local_path
      }
    end
  end
end