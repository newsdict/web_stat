RSpec.describe WebStat::Configure do
  it "Get Config by Singleton" do
    configure = WebStat::Configure.get
    expect(configure).not_to eq nil
  end

  it "Readable Config" do
    config = WebStat::Configure.get

    expect(config["min_length_of_meta_title"]).to eq 10
    expect(config["regex_to_sprit_title"]).to eq '\||-|:|｜|：|〜|\~| – '
  end

  it "Get thumbnail_regex.youtube." do
    config = WebStat::Configure.get
    expect(config["thumbnail_regex"]["yotube"].nil?).to eq true
    expect(config["id_extraction_regexs"]["youtube"]).to be_a String
    expect(config["thumbnail_regex"]["youtube"]).to be_a String
  end

  it "Match youtube url." do
    sample_url = "https://www.youtube.com/watch?v=aChpsuUffUM"
    WebStat::Configure.get["id_extraction_regexs"].each do |provider, regex_string|
      if sample_url.match(regex_string)
        expect(sample_url.gsub(%r{#{regex_string}}, WebStat::Configure.get["thumbnail_regex"][provider])).to eq 'http://img.youtube.com/vi/aChpsuUffUM/default.jpg'
      end
    end
  end
end