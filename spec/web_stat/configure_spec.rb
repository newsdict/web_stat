RSpec.describe WebStat::Configure do
  it "Get Config by Singleton" do
    configure = WebStat::Configure.new
    
    expect(configure.config).to eq nil
    expect(configure.singleton).to eq configure.config
    expect(configure.config).not_to eq nil
  end
  
  it "Readable Config" do
    config = WebStat::Configure.new.singleton  
    
    expect(config["min_length_of_meta_title"]).to eq 10
    expect(config["regex_to_sprit_title"]).to eq '\||-|:|｜|：|〜|\~| – '
  end
end