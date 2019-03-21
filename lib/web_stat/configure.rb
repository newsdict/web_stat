require 'yaml'
module WebStat
  class Configure
    DEFAULT_CONFIG_FILE_PATH = 'config/web_stat.yml'
    attr_accessor :config
    
    def self.get
      @config = self.singleton
    end
    
    # Get config by singleton
    def singleton
      if @config.nil?
        @config = YAML.load_file(get_configure_path)
      end
      @config
    end
    
    # Get configure path
    def get_configure_path
      File.join(File.expand_path("../", __FILE__), DEFAULT_CONFIG_FILE_PATH)
    end
  end
end