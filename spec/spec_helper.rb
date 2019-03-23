require "bundler/setup"
require "web_stat"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module WebStatTestHelper
  class << self
    # htmls of fixture
    def htmls
      Dir.glob(File.join(File.dirname(__FILE__), "fixtures", "htmls", "*.html")).map do |file|
        File.open(file).read
      end
    end
    
    # one html
    def html
      htmls.first
    end
  end
end