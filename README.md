# WebStat

Fetch the web pages and stat.

## Requirements

-  [MeCab _0.996_](http://taku910.github.io/mecab/#download)
- add runtime dependency
 - "bundler", "~> 2.0"
 - "nokogiri", "~> 1.10"
 - "mechanize", "~> 2.7"
 - "ruby-readability", "~> 0.7"
 - "final_redirect_url", "~> 0.1.0"
 - "natto", "~> 1.1.2"
- add development dependency
 - "rake", "~> 10.0"
 - "rspec", "~> 3.0"
- "rake", "~> 10.0"
- "rspec", "~> 3.0"

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'web_stat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install web_stat

## Usage

you can customize web_stat config.

And then execute:

    $ rake web_stat:install

### spec

  $ bundle exec rake spec

Test a file

  $ bundle exec rspec spec/web_stat/fetch_spec.rb 
