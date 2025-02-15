# test_scraper.rb
require_relative 'app/services/web_scraper_service'

url = "https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c06"
# url = "https://www.flipkart.com/poco-x7-pro-5g-yellow-256-gb/p/itm0a066ed95064a?pid=MOBH7YZ9J6QGZZEQ&lid=LSTMOBH7YZ9J6QGZZEQCBSSSP&param=17493&otracker=clp_bannerads_1_20.bannerAdCard.BANNERADS_A_mobile-phones-store_AKZK50HD8UDG"
scraper = WebScraperService.new(url)
result = scraper.scrape
puts "Result: #{result.inspect}"