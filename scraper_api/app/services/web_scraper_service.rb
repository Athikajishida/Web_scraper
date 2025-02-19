# @file app/services/web_scraper_service.rb
# @description Web scraping service for extracting product details from Flipkart using Selenium WebDriver.
#              This service automates browser interactions to scrape dynamically loaded content.
# @version 1.0.0 - Initial implementation with brand, title, price, description, and image extraction.
#                  Uses Selenium WebDriver with Chrome for automated scraping.
# @dependencies Selenium-WebDriver, Logger
# @usage WebScraperService.new(url).scrape
# @authors
#  - Athika Jishida

require 'selenium-webdriver'
require 'logger'

class WebScraperService
  def initialize(url)
    @url = url
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  # Scrapes product details from Flipkart
  # @return [Hash] A hash containing brand, title, price, description, website, image URL, and currency.
  def scrape
    setup_driver
    @logger.info("Starting to scrape: #{@url}")

    begin
      @driver.get(@url)
      @logger.info("Page loaded")

      scroll_down  # Scroll to load dynamic content

      # Save page source for debugging
      File.write("debug_page.html", @driver.page_source)
      brand = find_element_xpath("//td[contains(@class,'Izz52n')]/ul/li")
      title = find_element_xpath("//span[contains(@class,'VU-ZEz')]")
      price = find_element_xpath("//div[contains(@class,'Nx9bqj CxhGGd')]")
      description = find_element_xpath("//div[contains(@class,'U+9u4yf')]")
      image = find_element_xpath("//img[contains(@class,'cPHDOP')]")&.attribute("src")


      @logger.info("Found Elements - Brand: #{!brand.nil?}, Title: #{!title.nil?}, Price: #{!price.nil?}, Description: #{!description.nil?}, Image: #{!image.nil?}")

      {
        brand: brand&.text&.strip, 
        title: title&.text&.strip,
        price: extract_price(price&.text),
        description: description&.text&.strip,
        website: 'www.flipkart.com',
        image_url: image,
        currency: 'INR'
      }
    rescue => e
      @logger.error("Scraping error: #{e.message}")
      raise e
    ensure
      @driver.quit if @driver
    end
  end

  private

  # Sets up Selenium WebDriver with Chrome options for headless browsing
  def setup_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1920,1080')
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument("--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")

    service = Selenium::WebDriver::Service.chrome(path: '/opt/homebrew/bin/chromedriver')

    @driver = Selenium::WebDriver.for :chrome, options: options, service: service
    @driver.manage.timeouts.implicit_wait = 10
    @logger.info("Driver setup complete")
  end

  # Finds an element using XPath and waits for it to be present
  # @param xpath [String] XPath of the element
  # @return [Selenium::WebDriver::Element, nil] The found element or nil if not found
  def find_element_xpath(xpath)
    wait = Selenium::WebDriver::Wait.new(timeout: 15) # Waits up to 15 seconds for element
    wait.until { @driver.find_element(:xpath, xpath) }
  rescue Selenium::WebDriver::Error::TimeoutError
    wait.until { @driver.find_element(:xpath, xpath) }
  rescue Selenium::WebDriver::Error::TimeoutError
    nil
  end

  # Scrolls down the page multiple times to load dynamic content
  def scroll_down
    3.times do
      @driver.execute_script("window.scrollBy(0, window.innerHeight);")
      sleep(2)
    end
  end
  
  # Extracts price from text by removing currency symbols
  # @param price_text [String] The raw price text extracted from the page
  # @return [Float, nil] The extracted price or nil if not found
  def extract_price(price_text)
    return nil if price_text.nil? || price_text.empty?
    price_text.gsub(/[^\d.]/, '').to_f
  end
end