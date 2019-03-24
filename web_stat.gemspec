
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
  spec.homepage      = 'https://newsdict.blog/web-stat/'
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "bundler", "~> 2.0"
  spec.add_runtime_dependency "nokogiri", "~> 1.10"
  spec.add_runtime_dependency "mechanize", "~> 2.7"
  spec.add_runtime_dependency "ruby-readability", "~> 0.7"
  spec.add_runtime_dependency "final_redirect_url", "~> 0.1.0"
  spec.add_runtime_dependency "natto", "~> 1.1.2"
  spec.add_runtime_dependency "sanitize", "~> 5.0.0" 
  
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
