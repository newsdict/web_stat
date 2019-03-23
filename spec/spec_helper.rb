require 'rspec/expectations'
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
RSpec::Matchers.define :be_string_or_nil do |expected|
  match do |actual|
    expected.is_a?(String) || expected.nil?
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
    
    # htmls of fixture
    def scheme_and_files
      Dir.glob(File.join(File.dirname(__FILE__), "fixtures", "htmls", "*.html")).map do |file|
        "file://#{file}"
      end
    end
  end
end