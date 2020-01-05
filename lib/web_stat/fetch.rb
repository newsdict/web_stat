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
      []
    # Get main section
    def content
      Sanitize.clean(Readability::Document.new(@nokogiri.at('body')).content)
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
      if ! path.nil? && path.match(/^\//)
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
      agent = Mechanize.new { |_agent| _agent.user_agent = WebStat::Configure.get["user_agent"] }
      image = agent.get(url)
      File.open(tmp_file, "w+b") do |_file|
        if image.class == Mechanize::File
          _file.puts(image.body)
        else
          _file.puts(image.body_io.read)
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
      document = agent.get(url, [], nil, { 'Accept-Language' => 'ja'})
      if document.class == Mechanize::File
        document.body
      else
        document.body.encode('UTF-8', document.encoding)
      end
    end
    
    # Get the informations of @url
    # @param [Hash] Specify a dictionary for each language code. example ) {"ja": /***/**.dic, "other": /***/***.dic}
    def stat(userdics: nil)
      clean_content = content.scrub('').gsub(/[\n\t\r　]/, "").gsub(/\s{2,}/, "\s")
      language_code = CLD.detect_language(clean_content)[:code]
      if userdics && userdics.has_key?(language_code)
        tag = WebStat::Tag.new("#{title} #{content}", userdic: userdics[language_code])
      elsif userdics && userdics.has_key?("other")
        tag = WebStat::Tag.new("#{title} #{content}", userdic: userdics["other"])
      else
        tag = WebStat::Tag.new("#{title} #{content}", userdic: WebStat::Configure.get["userdic"])
      end
      {
        title: title,
        site_name: site_name,
        content: clean_content,
        language_code: language_code,
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
