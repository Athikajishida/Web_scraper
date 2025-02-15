class ScrapeProductJob < ApplicationJob
  queue_as :default
  
  def perform(product_id)
    product = Product.find(product_id)
    product.update(status: :processing)
    
    scraper = WebScraperService.new(product.url)
    product_data = scraper.scrape
    
    product.update!(
      product_data.merge(
        status: :completed,
        last_scraped_at: Time.current
      )
    )
  rescue => e
    product.update(
      status: :failed,
      error_message: e.message
    )
    raise e
  end
end