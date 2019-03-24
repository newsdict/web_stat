require 'rbconfig'
namespace :web_stat do
  desc "install web_stat"
  task :install do
    p RbConfig::CONFIG
    # install custom configure
    #dirname = File.dirname(WebStat::Configure.get_custom_configure_path)
    #Dir.mkdir(dirname) unless File.directory?(dirname)
    #FileUtils.cp(WebStat::Configure.get_default_configure_path, dirname)
    # install mecab
    
  end
end