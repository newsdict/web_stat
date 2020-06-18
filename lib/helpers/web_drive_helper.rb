module WebStat
  class WebDriverHelper
    class << self
      # Get last url
      # @param [String] url
      # @param [Integer] delay
      def get_last_url(url, delay=nil)
        driver = get_driver(url, delay)
        last_url = driver.current_url
        driver.quit
        last_url
      end
      # Get source of html
      # @param [String] url
      # @param [Integer] delay
      def get_source(url, delay=nil)
        driver = get_driver(url, delay)
        source = driver.page_source
        driver.quit
        source
      end
      
      private
      def get_driver(url, delay=nil)
        Selenium::WebDriver.logger.output = File.join("/tmp", "selenium.log")
        Selenium::WebDriver.logger.level = :info
        options = Selenium::WebDriver::Chrome::Options.new(args: [
          'headless',
          'no-sandbox',
          'disable-gpu'
          ])
        driver = Selenium::WebDriver.for(:chrome, options: options)
        driver.manage.timeouts.implicit_wait = 10
        Selenium::WebDriver::Wait.new(timeout: 10)
        driver.get(url)
        if delay.is_a?(Integer)
          sleep delay
        end
        driver
      end
    end
  end
end