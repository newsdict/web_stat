# WebStat

Fetch the web pages and stat.

### Install mecab

    $ sudo apt install mecab-ipadic-utf8 libmecab

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

  $ docker/start -d
  $ docker/exec ENV=development bundle exec rspec

Test a file

  $ docker/start -d
  $ docker/exec ENV=development bundle exec rspec spec/web_stat/fetch_spec.rb 
