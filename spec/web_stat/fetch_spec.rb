RSpec.describe WebStat::Fetch do
  [{fixture: WebStatTestHelper.htmls, class: WebStat::FetchAsHtml},
   {fixture: WebStatTestHelper.scheme_and_files, class: WebStat::FetchAsWeb}].each do |fetch|

    it "Get title by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        expect(web_stat.title).to eq "gem作成でついまずいたところ"
      end
    end

    it "Get site name by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        expect(web_stat.site_name).to eq "newsdict.blog"
      end
    end

    it "Get Document's content by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        expect(web_stat.content).not_to eq nil
      end
    end

    it "WebStat content do not include html by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        expect(Sanitize.clean(web_stat.content).length).to eq web_stat.content.length
      end
    end

    it "Get eyecatch image blob  by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        web_stat.url = "https://newsdict.blog"
        unless web_stat.stat[:eyecatch_image_path].nil?
          image = File.read(web_stat.stat[:eyecatch_image_path])
          expect(image.encoding.to_s).to eq("UTF-8")
        end
      end
    end

    it "Get eyecatch image path by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        web_stat.url = "https://newsdict.blog"
        expect(web_stat.eyecatch_image_path).to be_string_or_nil
      end
    end

    it "Get language_iso by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        web_stat.url = "https://newsdict.blog"
        expect(web_stat.stat[:language_code]).to eq("ja")
      end
    end

    it "Get local path of eyecatch image by #{fetch[:class].to_s}" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        web_stat.url = "https://newsdict.blog"
        expect(web_stat.stat[:eyecatch_image_path]).to be_tmp_file_or_nil
      end
    end
  end

  it "WebStat.stat_by_html" do
    WebStatTestHelper.htmls.each do |fixture|
      web_stat = WebStat.stat_by_html(fixture, "https://newsdict.blog")
      expect(web_stat[:title]).to eq "gem作成でついまずいたところ"
      expect(web_stat[:site_name]).to eq "newsdict.blog"
      expect(web_stat[:content]).not_to eq nil
      expect(Sanitize.clean(web_stat[:content]).length).to eq web_stat[:content].length
      expect(web_stat[:eyecatch_image_path]).to be_tmp_file_or_nil
    end
  end

  it "WebStat.stat_by_url" do
    WebStatTestHelper.scheme_and_files.each do |fixture|
      web_stat = WebStat.stat_by_url(fixture)
      expect(web_stat[:title]).to eq "gem作成でついまずいたところ"
      expect(web_stat[:site_name]).to eq "newsdict.blog"
      expect(web_stat[:content]).not_to eq nil
      expect(Sanitize.clean(web_stat[:content]).length).to eq web_stat[:content].length
      expect(web_stat[:eyecatch_image_path]).to be_tmp_file_or_nil
    end
  end
end
