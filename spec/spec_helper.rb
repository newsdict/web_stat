require 'rspec/expectations'
require "bundler/setup"
require 'pry'
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
    actual.nil?  || actual.is_a?(String)
  end
end
RSpec::Matchers.define :be_tmp_file_or_nil do |expected|
  match do |actual|
    (actual.is_a?(String) && actual.match(/^\/tmp/)) || actual.nil?
  end
end
RSpec::Matchers.define :be_array_or_nil do |expected|
  match do |actual|
     actual.nil? || actual.is_a?(Array)
  end
end

module WebStatTestHelper
  class << self
    # Get htmls of fixture
    def htmls
      Dir.glob(File.join(File.dirname(__FILE__), "fixtures", "htmls", "*.html")).map do |file|
        File.open(file).read
      end
    end
    
    # Get html of fixture by name
    def html(name)
      File.open(File.join(File.dirname(__FILE__), "fixtures", "htmls", "#{name}")).read
    end
    
    # Get htmls of fixture
    def scheme_and_files
      Dir.glob(File.join(File.dirname(__FILE__), "fixtures", "htmls", "*.html")).map do |file|
        "file://#{file}"
      end
    end
  end
end