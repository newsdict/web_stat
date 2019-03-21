namespace :web_stat do
  desc "install web_stat"
  task :install do
    dirname = File.dirname(WebStat::Configure::DEFAULT_CONFIG_FILE_PATH)
    Dir.mkdir(dirname) unless File.directory?(dirname)
    FileUtils.cp(WebStat::Configure.new.get_configure_path, dirname)
  end
end