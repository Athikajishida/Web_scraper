# test_scraper.rb
require_relative 'app/services/web_scraper_service'

url = "https://www.flipkart.com/sandwich-makers/pr?sid=j9e%2Cm38%2C1vj&otracker=nmenu_sub_Appliances_0_Sandwich%20Makers&otracker=nmenu_sub_TVs%20%26%20Appliances_0_Sandwich%20Makers"
# url = "https://www.flipkart.com/poco-x7-pro-5g-yellow-256-gb/p/itm0a066ed95064a?pid=MOBH7YZ9J6QGZZEQ&lid=LSTMOBH7YZ9J6QGZZEQCBSSSP&param=17493&otracker=clp_bannerads_1_20.bannerAdCard.BANNERADS_A_mobile-phones-store_AKZK50HD8UDG"
scraper = WebScraperService.new(url)
result = scraper.scrape
puts "Result: #{result.inspect}"