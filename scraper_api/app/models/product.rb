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