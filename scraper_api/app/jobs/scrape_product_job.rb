# @file spec/jobs/scrape_product_job_spec.rb
# @description Tests for ScrapeProductJob, ensuring it correctly enqueues jobs, updates product records,
#              and handles success & failure cases of scraping.
# @version 1.0.0 - Initial test coverage for job execution and product updates.
# @authors
#  - Athika Jishida


class ScrapeProductJob < ApplicationJob
  queue_as :default
 
  def perform(product_id)
    @product = Product.find(product_id)
    @product.update(status: :processing, last_scraped_at: Time.current)
    
    begin
      scraper = WebScraperService.new(@product.url)
      result = scraper.scrape
     
      @product.update!(
        title: result[:title],
        description: result[:description],
        price: result[:price],
        currency: result[:currency],
        brand: result[:brand],
        image_url: result[:image_url],
        website: result[:website],
        status: :completed,
        error_message: nil,
        additional_info: build_additional_info(result)
      )
    rescue StandardError => e
      Rails.logger.error("Scraping failed for product #{product_id}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      
      @product.update(
        status: :failed,
        error_message: e.message
      )
      
      # Optionally, you might want to retry the job
      # retry_job wait: 30.seconds if @product.retries < 3
    end
  end
  
  private
  
  def build_additional_info(result)
    {
      scraping_timestamp: Time.current.iso8601,
      price_history: update_price_history(result[:price]),
      availability: result[:price].present? ? "in_stock" : "unknown"
    }
  end
  
  def update_price_history(new_price)
    return [] unless new_price
    
    history = @product.additional_info&.dig("price_history") || []
    history << {
      price: new_price,
      recorded_at: Time.current.iso8601
    }
    
    # Keep last 10 price points
    history.last(10)
  end
end