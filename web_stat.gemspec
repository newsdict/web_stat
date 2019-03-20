
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
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
