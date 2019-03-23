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
end