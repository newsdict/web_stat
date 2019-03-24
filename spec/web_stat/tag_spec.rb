RSpec.describe WebStat::Tag do
  [{ fixture: WebStatTestHelper.htmls, class: WebStat::FetchAsHtml},
  { fixture: WebStatTestHelper.scheme_and_files, class: WebStat::FetchAsWeb}].each do |fetch|
      
    it "Morphological element analysis" do
      fetch[:fixture].each do |fixture|
        web_stat = fetch[:class].new(fixture)
        tag = WebStat::Tag.new(web_stat.content)
        expect(tag.nouns).to be_array_or_nil
      end
    end
    
  end
end