require 'selenium-webdriver'
require 'uri'

class WebScraperService
  class ScrapingError < StandardError; end
  
  def initialize(url)
    @url = url
    @uri = URI.parse(url)
    @website = @uri.host
    setup_driver
  end

  def scrape
    @driver.get(@url)
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    
    case @website
    when 'www.flipkart.com'
      scrape_flipkart(wait)
    when 'www.amazon.com'
      scrape_amazon(wait)
    else
      scrape_generic(wait)
    end
  rescue => e
    raise ScrapingError, "Scraping failed: #{e.message}"
  ensure
    @driver.quit
  end
  
  private
  
  def setup_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def scrape_flipkart(wait)
    wait.until { @driver.find_element(css: '.B_NuCI') }
    {
      title: @driver.find_element(css: '.B_NuCI').text.strip,
      price: extract_price(@driver.find_element(css: '._30jeq3._16Jk6d').text),
      description: @driver.find_element(css: '._1mXcCf.RmoJUa').text.strip,
      brand: @driver.find_element(css: '.G6XhRU').text.strip,
      website: @website,
      additional_info: extract_flipkart_details
    }
  end

  def scrape_amazon(wait)
    wait.until { @driver.find_element(css: '#productTitle') }
    {
      title: @driver.find_element(css: '#productTitle').text.strip,
      price: extract_price(@driver.find_element(css: '.a-price-whole').text),
      description: @driver.find_element(css: '#productDescription p').text.strip,
      brand: @driver.find_element(css: '#bylineInfo').text.strip,
      website: @website,
      additional_info: extract_amazon_details
    }
  end

  def scrape_generic(wait)
    wait.until { @driver.find_element(css: 'h1, title') }
    {
      title: @driver.find_element(css: 'h1, title').text.strip,
      price: extract_generic_price,
      description: extract_generic_description,
      brand: extract_generic_brand,
      website: @website,
      additional_info: {}
    }
  end

  def extract_flipkart_details
    details = {}
    @driver.find_elements(css: '._14cfVK').each do |item|
      key = item.find_element(css: '._1hKmbr').text.strip
      value = item.find_element(css: '.URwL2w').text.strip
      details[key] = value
    end
    details
  end

  def extract_amazon_details
    details = {}
    @driver.find_elements(css: '#productDetails_db_sections tr').each do |row|
      key = row.find_element(css: 'th').text.strip
      value = row.find_element(css: 'td').text.strip
      details[key] = value
    end
    details
  end

  def extract_price(price_text)
    return nil if price_text.nil? || price_text.empty?
    price_text.gsub(/[^\d.]/, '').to_f
  end

  def extract_generic_price
    price_elements = @driver.find_elements(css: '[class*=price], [id*=price]')
    price_text = price_elements.find { |el| el.text.match?(/\d+/) }&.text
    extract_price(price_text)
  end

  def extract_generic_description
    desc_elements = @driver.find_elements(css: '[class*=description], [id*=description]')
    desc_elements.map(&:text).reject(&:empty?).join(' ')
  end

  def extract_generic_brand
    brand_elements = @driver.find_elements(css: '[class*=brand], [id*=brand]')
    brand_elements.map(&:text).reject(&:empty?).join(' ')
  end
end
