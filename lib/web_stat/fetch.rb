module WebStat
  class Fetch
    attr_accessor :url, :html, :nokogiri, :userdic, :status, :header
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
      if title.nil?
        "No Title"
      else
        title.strip
      end
    end

    # Get name of domain
    def site_name
      begin
        site_name = @nokogiri.title.split(/#{WebStat::Configure.get["regex_to_sprit_title"]}/, 2).last
      rescue
        site_name = @nokogiri.title
      end
      if site_name.nil?
        "No Sitename"
      else
        site_name.strip
      end
    end
    # Get main section
    def content
      if @url&.match(WebStat::Configure.get["id_extraction_regexs"]["youtube"])
        youtube_decscription
      else
        Sanitize.clean(Readability::Document.new(@nokogiri.at('body').to_s).content)
      end
    end
    
    # Get describe of youtube movie.
    def youtube_decscription
      regex_string = WebStat::Configure.get["id_extraction_regexs"]["youtube"]
      if @url.match(regex_string)
        id = @url.gsub(%r{#{regex_string}.*$}, '\1')
        youtube = Google::Apis::YoutubeV3::YouTubeService.new
        youtube.key = WebStat::Configure.get["api_keys"]["youtube"]
        response = youtube.list_videos(:snippet, id: id)
        response.items.first.snippet.description
      end
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
      # If there is a thumbnail rule, apply it.
      WebStat::Configure.get["id_extraction_regexs"].each do |provider, regex_string|
        if @url.match(regex_string)
          return @url.gsub(%r{#{regex_string}.*$}, WebStat::Configure.get["thumbnail_regex"][provider])
        end
      end
      readability_content = ::Nokogiri::HTML(Readability::Document.new(@nokogiri.at('body').to_s).content)
      if (path.nil? || path.empty?) && readability_content.xpath('//img').first
        path =  readability_content.xpath('//img').first.attr('src')
      end
      if (path.nil? || path.empty?) && @nokogiri.xpath('//img').first
        path = @nokogiri.xpath('//img').first.attr('src')
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
      return nil if url.nil? || ! url.match(%{^http})
      tmp_file = "/tmp/#{Digest::SHA1.hexdigest(url)}"
      agent = Mechanize.new { |_agent| _agent.user_agent = WebStat::Configure.get["user_agent"] }
      image = agent.get(url)
      File.open(tmp_file, "w+b") do |_file|
        if image.class == Mechanize::File
          _file.puts(image.body)
        elsif image.respond_to?(:body_io)
          _file.puts(image.body_io.read)
        end
      end
      tmp_file
    rescue
      false
    end

    # Get url
    # @param [String] url
    # @param [String] body
    def get_url(url)
      mech = Mechanize.new { |_mech| _mech.user_agent = WebStat::Configure.get["user_agent"] }
      # Enable to read Robots.txt
      mech.robots = true
      begin
        if mech.agent.robots_disallowed?(url)
          raise Mechanize::RobotsDisallowedError.new(url)
        end
        document = mech.get(url, [], nil, { 'Accept-Language' => 'ja'})
        @header = document.header
        begin
          raise 'not_use_chromedirver' unless WebStat::Configure.get["use_chromedirver"]
          body = WebStat::WebDriverHelper.get_source(url)
          @status = 200
        rescue
          if document.class == Mechanize::File
            body = document.body
          else
            body = document.body.encode('UTF-8', document.encoding)
          end
          @status = document.code
        end
      rescue Mechanize::ResponseCodeError => e
        body = e.page.body
        @status = e.page.code
      end
      body
    end
    
    # Return Date or last modified header.
    # @param [String] url
    # @return DataTime
    def get_last_modified
      @header = @header || {}
      if @header.has_key?("date") && @header.has_key?("last-modified")
        if DateTime.parse(@header["date"]) >= DateTime.parse(@header["last-modified"])
          DateTime.parse(@header["date"])
        else
          DateTime.parse(@header["last-modified"])
        end
      elsif @header.has_key?("date")
        DateTime.parse(@header["date"])
      elsif @header.has_key?("last-modified")
        DateTime.parse(@header["last-modified"])
      end
    end

    # Get the informations of @url
    # @param [Hash] Specify a dictionary for each language code. example ) {"ja": /***/**.dic, "other": /***/***.dic}
    def stat(userdics: nil)
      clean_content = content.scrub('').gsub(/[\n\t\r　]/, "").gsub(/\s{2,}/, "\s").gsub(URI.regexp, "")
      language_code = CLD.detect_language(clean_content)[:code]
      if userdics && userdics.has_key?(language_code) && File.exists?(userdics[language_code])
        tag = WebStat::Tag.new("#{title} #{content}", userdic: userdics[language_code])
      elsif userdics && userdics.has_key?("other") && File.exists?(userdics["other"])
        tag = WebStat::Tag.new("#{title} #{content}", userdic: userdics["other"])
      else
        tag = WebStat::Tag.new("#{title} #{content}", userdic: WebStat::Configure.get["userdic"])
      end
      {
        title: title,
        site_name: site_name,
        content: clean_content,
        language_code: language_code,
        status: @status,
        url: @url,
        last_modified_at: get_last_modified,
        eyecatch_image_path: save_local_path(eyecatch_image_path),
        tags: tag.nouns
      }
    end

    private

    # Get original url
    # @param [String] url
    def original_url(url)
      last_url = WebStat::FinalRedirectUrl.final_redirect_url(url)
      unless last_url.nil? || last_url.scrub('').empty?
        last_url
      else
        url
      end
    end
  end
end
