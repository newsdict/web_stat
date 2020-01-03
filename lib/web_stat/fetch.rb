module WebStat
  class Fetch
    attr_accessor :url, :html, :nokogiri, :userdic

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
      Sanitize.clean(Readability::Document.new(@html).content)
    end
      
    # Get temporary path of image
    def eyecatch_image_path
      # Reuse `path` in this method
      path = nil
      WebStat::Configure.get["eyecatch_image_xpaths"].each do |xpath|
        if @nokogiri.xpath(xpath).first.respond_to?(:value)
          path = @nokogiri.xpath(xpath).first.value
          break
        end
      end
      if path.match(/^\//)
        "#{URI.parse(@url).scheme}://#{URI.parse(@url).host}#{path}"
      else
        path
      end
    end
    
    # Get local path to save url
    # @param [String] url
    def save_local_path(url)
      return nil if url.nil?
      tmp_file = "/tmp/#{Digest::SHA1.hexdigest(url)}"
      URI.open(original_url(url)) do |remote_file|
        File.open(tmp_file, "w+b") do |_file|
          _file.puts(remote_file.read)
        end
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
      content.gsub!(/(\n|\t|\s|　)/, "")
      tag = WebStat::Tag.new(content, userdic: WebStat::Configure.get["userdic"])
      {
        title: title,
        site_name: site_name,
        content: content,
        language_code: CLD.detect_language(content)[:code],
        url: @url,
        eyecatch_image_path: save_local_path(eyecatch_image_path),
        tags: tag.nouns
      }
    end

    private

    # Get original url
    # @param [String] url
    def original_url(url)
      if url.match(/^http/)
        FinalRedirectUrl.final_redirect_url(url)
      else
        url
      end
    end
  end
end
