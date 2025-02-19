# @file app/models/product.rb
# @description Model representing a product, stores details scraped from external websites.
# @version 1.0.0 - Initial schema with title, price, currency, image_url, and scraping status fields. Added validations and JSON serialization for additional_info field. 
# @authors
#  - Athika Jishida

class Product < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  
  enum status: {
    pending: 'pending',
    processing: 'processing',
    completed: 'completed',
    failed: 'failed'
  }
 
  def needs_update?
    last_scraped_at.nil? || last_scraped_at < 7.days.ago
  end
end