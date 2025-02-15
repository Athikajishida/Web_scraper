require 'selenium-webdriver'

# Setup Chrome options
options = Selenium::WebDriver::Chrome::Options.new
# Comment out the headless mode to see the browser
# options.add_argument('--headless')

driver = Selenium::WebDriver.for :chrome, options: options
driver.get('https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c06')

sleep 5 # Allow time for elements to load

puts "Page Source: #{driver.page_source}" # Check if page content is loaded
driver.quit
