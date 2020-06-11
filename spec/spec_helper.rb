require 'rspec/expectations'
require "bundler/setup"
require 'pry'
require 'pry-byebug'
require "web_stat"

require 'webmock'
include WebMock::API
WebMock.enable!

WebMock.disable_net_connect!({
  allow_localhost: true,
  allow: 'chromedriver.storage.googleapis.com'
})

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
	"https://newsdict.blog/#{File.basename(file)}"
      end
    end
  end
end

# Set webmock
WebStatTestHelper.scheme_and_files.each do |url|
  status = [200, 404, 503].sample
  WebMock.stub_request(:get, url)
    .to_return(
      status: status,
      body: File.new(File.join(File.dirname(__FILE__), "fixtures", "htmls", File.basename(url))),
      headers: {content_type: 'application/html; charset=utf-8'})
end

WebMock.stub_request(:get, "https://newsdict.blog/robots.txt")
    .to_return(
      status: 200,
      body: "User-agent: *
Sitemap: https://newsdict.blog/sitemap.xml
Disallow: /ghost/
Disallow: /p/",
      headers: {content_type: 'application/html; charset=utf-8'})

WebMock.stub_request(:get, "https://newsdict.blog/content/images/size/w100/2019/03/facebook-3.jpg")
    .to_return(
      status: 200,
      body: File.new(File.join(File.dirname(__FILE__), "fixtures", "images", "facebook-3.jpg")),
      headers: {content_type: 'application/html; charset=utf-8'})

WebMock.stub_request(:get, "https://cdn.newsdict.jp/assets/newsdict-5d8601394c3f4eea2d7161ab92ab327ac7099e22214c853327011b3a71859b8e.png")
    .to_return(
        status: 200,
        body: File.new(File.join(File.dirname(__FILE__), "fixtures", "images", "newsdict-5d8601394c3f4eea2d7161ab92ab327ac7099e22214c853327011b3a71859b8e.png")),
        headers: {content_type: 'application/html; charset=utf-8'})