module WebStat
  class Fetch
    attr_accessor :url
    
    # initialize class
    def initialize(url)
      @url = url
    end
    
    # Get html
    # @return [String] HTML
    def get_html; end
    
    # Get title
    # @return [String] title
    def title; end
    
    # Get name of domain 
    def site_name; end
      
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