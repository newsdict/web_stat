require "bundler/gem_tasks"
require "rspec/core/rake_task"
load 'lib/web_stat.rb'
load "lib/web_stat/tasks/install.rake"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
