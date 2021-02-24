
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "web_stat/version"

Gem::Specification.new do |spec|
  spec.name          = "web_stat"
  spec.version       = WebStat::VERSION
  spec.authors       = ["yusuke abe"]
  spec.email         = ["yube@newsdict.jp"]
  spec.summary       = "Get the status of  the web pages."
  spec.description   = <<-EOS.strip.gsub(/\s+/, ' ')
    Fetch the web pages and stat.
  EOS
  spec.homepage      = "https://github.com/newsdict/web_stat"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "bundler", ">= 2.0.2"
  spec.add_runtime_dependency "nokogiri", ">= 1.10.4"
  spec.add_runtime_dependency "mechanize", ">= 2.7.7"
  spec.add_runtime_dependency "ruby-readability", ">= 0.7"
  spec.add_runtime_dependency "natto", ">= 1.1.2"
  spec.add_runtime_dependency "sanitize", ">= 5.0.0"
  spec.add_runtime_dependency "cld", ">= 0.8.0"
  spec.add_runtime_dependency "selenium-webdriver", "= 3.142.7"
  spec.add_runtime_dependency "pdf-reader", "2.4.0"
  spec.add_runtime_dependency "webrick", ">= 1.7.0"
  spec.add_runtime_dependency "rexml", ">= 3.2.4"

  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "pry", ">= 0.13.1"
  spec.add_development_dependency "webmock", ">= 3.8.3"
  spec.add_development_dependency "pry-byebug", "3.9.0"
end
