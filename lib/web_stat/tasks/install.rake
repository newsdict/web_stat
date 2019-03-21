namespace :web_stat do
  desc "install web_stat"
  task :install do
    # install custom configure
    dirname = File.dirname(WebStat::Configure.new.get_custom_configure_path)
    Dir.mkdir(dirname) unless File.directory?(dirname)
    FileUtils.cp(WebStat::Configure.new.get_default_configure_path, dirname)
  end
end