require 'yaml'
module WebStat
  class Configure
    DEFAULT_CONFIG_FILE_PATH = 'config/web_stat.yml'
    
    # Get yaml
    def self.get
      YAML.load_file(self.get_configure_path)
    end
    
    # Get configure path
    def self.get_configure_path
      if File.exists?(self.get_custom_configure_path)
        self.get_custom_configure_path
      else
        self.get_default_configure_path
      end
    end
    
    # Get default configure path
    def self.get_default_configure_path
      File.join(File.expand_path("../", __FILE__), DEFAULT_CONFIG_FILE_PATH)
    end
    
    # Get custom configure path
    def self.get_custom_configure_path
      File.join(Bundler.root, DEFAULT_CONFIG_FILE_PATH)
    end
  end
end