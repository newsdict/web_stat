RSpec.describe WebStat::Fetch do
  it "Get title" do
    WebStatTestHelper.htmls.each do |html|
      web_stat = WebStat::FetchAsHtml.new(html)
      expect(web_stat.title).to eq "gem作成でついまずいたところ"
    end
  end
  
  it "Get site name" do
    WebStatTestHelper.htmls.each do |html|
      web_stat = WebStat::FetchAsHtml.new(html)
      expect(web_stat.site_name).to eq "newsdict.blog"
    end
  end
  
  it "Get title by FetchAsWeb" do
    WebStatTestHelper.scheme_and_files.each do |scheme_and_file|
      web_stat = WebStat::FetchAsWeb.new(scheme_and_file)
      expect(web_stat.title).to eq "gem作成でついまずいたところ"
    end
  end
end