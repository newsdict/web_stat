require "bundler"
Dir.glob("**/*.rb", base: 'lib').each do |file|
  require(file)
end

module Webstat
end
