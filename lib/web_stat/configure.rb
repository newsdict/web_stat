require 'yaml'
module WebStat
  class Configure
    attr_accessor :config
    
    def self.get
      @config = self.singleton
    end
    
    # Get config by singleton
    def singleton
      if @config.nil?
         @config = YAML.load_file(File.join(File.expand_path("../", __FILE__), 'config/web_stat.yml'))
      end
      @config
    end
  end
end