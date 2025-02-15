RSpec.configure do |config|
  config.before(:each, type: :selenium) do
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  config.after(:each, type: :selenium) do
    @driver.quit if @driver
  end
end