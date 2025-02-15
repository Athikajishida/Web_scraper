if Rails.env.test?
  require 'selenium/webdriver'
  
  Selenium::WebDriver.logger.level = :warn
  
  # Register Chrome driver
  Selenium::WebDriver::Chrome::Service.driver_path = `which chromedriver`.chomp #This sets ChromeDriver’s executable path dynamically.
end
