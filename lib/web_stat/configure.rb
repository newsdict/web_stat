require 'yaml'
module WebStat
  class Configure
    DEFAULT_CONFIG_FILE_PATH = 'config/web_stat.yml'
    
    class << self
      # Get yaml
      def get
        if defined? Rails
          YAML.load_file(get_configure_path)[Rails.env]
        else
          YAML.load_file(get_configure_path)["production"]
        end
      end
      
      # Get configure path
      def get_configure_path
        if File.exists?(get_custom_configure_path)
          get_custom_configure_path
        else
          get_default_configure_path
        end
      end
      
      # Get default configure path
      def get_default_configure_path
        File.join(File.expand_path("../", __FILE__), DEFAULT_CONFIG_FILE_PATH)
      end
      
      # Get custom configure path
      def get_custom_configure_path
        if defined? Rails
  	      File.join(Rails.root, DEFAULT_CONFIG_FILE_PATH)
        else
          File.join(Bundler.root, DEFAULT_CONFIG_FILE_PATH)
        end
      end
    end
  end
end
